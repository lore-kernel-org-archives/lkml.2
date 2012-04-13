Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298Ab2DMLQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:16:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53515 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2DMLQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:16:54 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: irq_domain fixes for v3.4-rc2
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
X-Yow: Is it 1974?  What's for SUPPER?  Can I spend my COLLEGE FUND in
 one wild afternoon??
Date: Fri, 13 Apr 2012 13:16:49 +0200
In-Reply-To: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
	(Grant Likely's message of "Wed, 11 Apr 2012 17:18:43 -0600")
Message-ID: <m27gxjnaou.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> I've pushed this out to the following branch for testing:
>
> git://git.secretlab.ca/git/linux-2.6 irqdomain/test

That doesn't work at all.  I get a warning in virq_to_hw and it hangs
later, probably during SMP bringup due to lost IPI interrupts.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
