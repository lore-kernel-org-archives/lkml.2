Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0FUOId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:08:33 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:62948 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab0FUOIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:08:32 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 10:08:32 EDT
Date: Mon, 21 Jun 2010 15:59:03 +0200 (CEST)
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Piotr Hosowicz <piotr@hosowicz.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's up with Linux git repo?
In-Reply-To: <4C1F698D.2060105@example.com>
Message-ID: <alpine.DEB.2.00.1006211557470.6123@odin.tweek.dk>
References: <4C1F698D.2060105@example.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jun 2010, Piotr Hosowicz wrote:

> Hello,
>
> I update regularly with git config:
>
>
> [core]
>        repositoryformatversion = 0
>        filemode = true
>        bare = false
>        logallrefupdates = true
> [remote "origin"]
>        fetch = +refs/heads/*:refs/remotes/origin/*
>        url = 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> [branch "master"]
>        remote = origin
>        merge = refs/heads/master
>
> Until few days ago there were updates but now I don't see any. Will somebody 
> tell me what's going on? Why there are no new updates? Is it because Linus 
> has vacation now, as I read in another thread?
>
> Regards,
>
> Piotr Hosowicz

Hi,

According to 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
there don't seem to be any update newer than 9 day atm.

Regards,
Martin
