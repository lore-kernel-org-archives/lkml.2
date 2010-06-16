Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab0FPPuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:50:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910Ab0FPPuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:50:14 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfsd hang and kernel bug in 2.6.35-rc3
References: <20100615175034.1e015fbc@boulder.homenet>
X-Yow: HELLO, little boys!   Gimme a MINT TULIP!!  Let's do the BOSSA NOVA!!
Date: Wed, 16 Jun 2010 17:50:09 +0200
In-Reply-To: <20100615175034.1e015fbc@boulder.homenet> (Chris Vine's message
	of "Tue, 15 Jun 2010 17:50:34 +0100")
Message-ID: <m3eig7ht8u.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Vine <chris@cvine.freeserve.co.uk> writes:

> Booting up kernel 2.6.35-rc3 on my netbook, with the kernel compiled for
> an Atom N270 processor, hangs when starting nfsd.

See <https://bugzilla.kernel.org/show_bug.cgi?id=16188>.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
