Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1JARyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:54:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54925 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JARyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:54:18 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andy <akwatts@ymail.com>
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com>
	<20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com>
	<20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus>
X-Yow: .. If I cover this entire WALL with MAZOLA, who I have to give my
 AGENT ten per cent??
Date: Sat, 01 Oct 2011 19:54:14 +0200
In-Reply-To: <20111001171916.GA11989@zeus> (Andy's message of "Sat, 1 Oct 2011
	12:19:16 -0500")
Message-ID: <m2hb3stx6h.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy <akwatts@ymail.com> writes:

> I must be doing something wrong. I only have the 2.6 git repo (so my tags
> don't drill down to 2.6.x.y just 2.6.x) but my experiement isn't giving
> the results I expected.
>
> [Cloned repo]
> $ git archive --format=tar --prefix linux-2.6.39/ v2.6.39 | md5sum
> 482f8bd941def0548a95f34e2d290dfd  -

Try setting tar.umask to 022 (default is 002).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
