Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2CUPII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:08:08 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38853 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2CUPIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:08:06 -0400
Date: Wed, 21 Mar 2012 08:08:01 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [REGRESSION][PATCH] Fix an old sky2 WOL regression
Message-ID: <20120321080801.55e4731b@nehalam.linuxnetplumber.net>
In-Reply-To: <4F69BE2E.7070903@t-online.de>
References: <4F69BE2E.7070903@t-online.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 12:40:30 +0100
Knut Petersen <Knut_Petersen@t-online.de> wrote:

> Sky2 Wake on LAN is broken since February 2010 on a number of systems.
> Yes. More than two years.
> 
> We know about the problem and the cause since October 2010
> (Bugzilla bug #19492). It´s commit 87b09f1f25cd1e01d7c50bf423c7fe33027d7511.
> 
> Stephen, David: You signed off that commit.
> 
> Andrew: You called it a regression in October 2010.
> 
> It has been proposed to revert the commit that caused the problem.
> Nothing happened.
> 
> I proposed to re-establish the old code for dmi_match()ed systems.
> Without success.
> 
> Now it is proposed to re-establish the old code as a configuration option.
> If nothing happens again I will propose a module parameter ;-)
> 
> Stephen, I don´t want to be a pain in the neck, and it is not my intention
> to offend you by my "attitude". But I simply cannot understand why this
> know regression is not fixed. The bit we talk about is documented,
> and in fact it was set for a number of kernel versions unconditionally.
> Nobody complained about ruined hardware or minor problems.
> 
> The systems affected are old enough that no manufacturer cares about
> them, but they are still quite usable for a lot of jobs (kernel 3.3 compile
> time here is below 15 minutes).
> 
> If there is a problem in the kernel and if we do know an easy solution,
> that solution should be commited to the kernel, no matter what is written
> in some random documentation, no matter if we could blame some
> BIOS authors. That´s the way Linux works - at least I thought so.
> 
> cu,
> Knut

Config options don't work for distro's.
