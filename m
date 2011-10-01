Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1JAUc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:32:27 -0400
Received: from 1wt.eu ([62.212.114.60]:33349 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791Ab1JAUcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:32:23 -0400
Date: Sat, 1 Oct 2011 22:32:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>, Andy <akwatts@ymail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001203218.GD14779@1wt.eu>
References: <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus> <20111001190612.GA14779@1wt.eu> <20111001192438.GA22938@kroah.com> <20111001200700.GG18690@1wt.eu> <m2aa9ktpz1.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2aa9ktpz1.fsf@igel.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 10:29:54PM +0200, Andreas Schwab wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > I discovered that 002/022 are not the only differences. Adrian used
> > to set 2.6.16.x at umask 000, and Linus changed the user in the
> > tarballs several times (torvalds, then git, then root). I'm also
> > seeing a certain greg/users for 2.6.11.x :-)
> 
> Obviously tarballs before 2.6.12 weren't created with git-archive and
> will contain unpredictable timestamps.

I did not remember when the git-tar command was introduced, but your
comment makes a lot of sense ! We're not much interested in 2.6.11
anyway I think.

Regards,
Willy

