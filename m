Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2C1P3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:29:20 -0400
Received: from plane.gmane.org ([80.91.229.3]:41882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab2C1P3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:29:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
Date: Wed, 28 Mar 2012 18:28:53 +0300
Organization: Lucas Barks
Message-ID: <jkvao0$b12$1@dough.gmane.org>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com> <201203240553.32526.gene.heskett@gmail.com> <57375.1332641134@turing-police.cc.vt.edu> <20120328051243.GA2138@fancy-poultry.org> <jkv0q5$kgu$1@dough.gmane.org> <20120328135336.GA1841@fancy-poultry.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-354751.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120325 Thunderbird/11.0
In-Reply-To: <20120328135336.GA1841@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/03/12 16:53, Heinz Diehl wrote:
> On 28.03.2012, Nikos Chantziaras wrote:
>
>> CFS: ALSA XRUNs in JACK.
>> BFS: much less ALSA XRUNs in JACK
>
> BFS runs on all of my machines, and I know why. But that's not the
> point here. Why do people not accept and learn from each other? I'm
> quite shure that both CFS and BFS has good and bad things, why not
> take the best from both of them and improve it further?

I totally agree.  What ticks me off is people who claim that using BFS 
means you must be schizophrenic, even though some of them posted 
numbers.  Even on servers, BFS helped people.  For example, a server 
running mainline was behaving badly until it was switched to BFS.  The 
difference was quite impressive:

http://ck-hack.blogspot.com/2011/08/phoronix-revisits-bfs.html

But still, many people decide to keep the "you're imagining it" 
attitude, as if they're preparing flame-bait.

