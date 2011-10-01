Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1JAUaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:30:05 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47655 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1JAU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:29:58 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, Andy <akwatts@ymail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com>
	<20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com>
	<20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus>
	<20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus>
	<20111001190612.GA14779@1wt.eu> <20111001192438.GA22938@kroah.com>
	<20111001200700.GG18690@1wt.eu>
X-Yow: By MEER biz doo SCHOIN..
Date: Sat, 01 Oct 2011 22:29:54 +0200
In-Reply-To: <20111001200700.GG18690@1wt.eu> (Willy Tarreau's message of "Sat,
	1 Oct 2011 22:07:00 +0200")
Message-ID: <m2aa9ktpz1.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> I discovered that 002/022 are not the only differences. Adrian used
> to set 2.6.16.x at umask 000, and Linus changed the user in the
> tarballs several times (torvalds, then git, then root). I'm also
> seeing a certain greg/users for 2.6.11.x :-)

Obviously tarballs before 2.6.12 weren't created with git-archive and
will contain unpredictable timestamps.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
