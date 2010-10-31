Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0JaP10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:27:26 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48086 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0JaP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:27:24 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why get/put_unaligned are hidden behind #ifdef __KERNEL__ on PowerPC and Microblaze?
References: <AANLkTimtfUXN9oTQ=BaxNz+h+mgwFBPrzN_Nggbai+ZJ@mail.gmail.com>
X-Yow: YOW!!  The land of the rising SONY!!
Date: Sun, 31 Oct 2010 16:27:22 +0100
In-Reply-To: <AANLkTimtfUXN9oTQ=BaxNz+h+mgwFBPrzN_Nggbai+ZJ@mail.gmail.com>
	(Igor Zhbanov's message of "Sun, 31 Oct 2010 18:13:31 +0300")
Message-ID: <m2bp6apelh.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Zhbanov <izh1979@gmail.com> writes:

> I have found that functions get_unaligned and put_unaligned from unaligned.h
> are hidden behind #ifdef __KERNEL__ on PowerPC and Microblaze architectures.
> And are not hidden on other platforms. But why?

Since <asm/unaligned.h> is not an exported header the point is moot.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
