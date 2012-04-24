Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2DXTP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:15:27 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53773 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2DXTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:15:26 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit modulus operation in a 32-bit kernel
References: <Pine.LNX.4.44L0.1204241347490.1511-100000@iolanthe.rowland.org>
X-Yow: TATTOOED MIDGETS are using ALFREDO in their SALAMI FACTORY!
Date: Tue, 24 Apr 2012 21:15:19 +0200
In-Reply-To: <Pine.LNX.4.44L0.1204241347490.1511-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 24 Apr 2012 13:50:01 -0400 (EDT)")
Message-ID: <m2lillj60o.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> I need to compute the remainder when a 64-bit quantity is divided by a 
> small value (126 in this case).  The % operator doesn't work in an 
> x86/32 kernel.  What's the Right Way to do it?

#include <asm/div64.h>

do_div(n,base) returns the remainder.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
