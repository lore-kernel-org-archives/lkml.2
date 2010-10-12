Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0JLOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:33:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab0JLOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:33:19 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Scalability to 48 cores
References: <4CB381DB.1040206@gmx.net>
Date: Tue, 12 Oct 2010 16:33:17 +0200
In-Reply-To: <4CB381DB.1040206@gmx.net> (Cyrus Massoumi's message of "Mon, 11
	Oct 2010 23:30:03 +0200")
Message-ID: <87wrpn1nwy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrus Massoumi <cyrusm@gmx.net> writes:

> A friend just sent me the following PDF about Linux Scalability to many cores and I thought it might be interesting to the list for further discussion.
> It's about scalability problems of the Linux kernel and applications
> with 48 and more cores.

Note that 48 cores is a small system these days.

> http://pdos.csail.mit.edu/papers/linux:osdi10.pdf

The paper is known, but it seems to be in the usual unproductive 
"publish a paper, but don't care about fixing anything" acedemic mode.

A lot of the issues described there are already being addressed
I believe.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
