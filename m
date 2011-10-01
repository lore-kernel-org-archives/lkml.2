Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1JAUHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:07:41 -0400
Received: from 1wt.eu ([62.212.114.60]:33343 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab1JAUHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:07:07 -0400
Date: Sat, 1 Oct 2011 22:07:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Andy <akwatts@ymail.com>, schwab@linux-m68k.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001200700.GG18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus> <20111001190612.GA14779@1wt.eu> <20111001192438.GA22938@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001192438.GA22938@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 12:24:38PM -0700, Greg KH wrote:
> Very nice, thanks so much for providing an independant verification of
> the tarballs, it is much appreciated.
> 
> And yes, the umask problem did trip us up when we did the initial
> verification as well, fun to see that you all figured out and solved the
> problem faster than I did :)

I found that one of the remote machines I have access to has a fast
access to a mirror. So I'm currently collecting tar.gz sigs and tar
sigs. I stopped checking bz2 because that small machine takes 20s to
bzcat one file (for <1s file transfer)!

I discovered that 002/022 are not the only differences. Adrian used
to set 2.6.16.x at umask 000, and Linus changed the user in the
tarballs several times (torvalds, then git, then root). I'm also
seeing a certain greg/users for 2.6.11.x :-)

I think it will be easier to reproduce the sigs from the tags once
we have all the elements to know how the tar files were produced.

I'll post the tarball sigs here once I get them all. That way it
will already be possible to check if different ones are found on
some mirrors.

Willy

