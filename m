Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0LCSrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 13:47:46 -0500
Received: from mailman.will.to ([68.164.136.125]:50812 "EHLO will.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab0LCSrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 13:47:46 -0500
Message-ID: <4CF93B4F.20506@will.to>
Date: Fri, 03 Dec 2010 13:47:43 -0500
From: Doug Hughes <doug@will.to>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: strange linux kernel NFS problem(s)
References: <4CF858A3.2050202@will.to> <19705.10909.860332.657164@quad.stoffel.home>
In-Reply-To: <19705.10909.860332.657164@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (will.to [68.164.136.125]); Fri, 03 Dec 2010 13:47:44 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> "Doug" == Doug Hughes<doug@will.to>  writes:
> Doug>  So, this is my first post, but not my first problem of this
> Doug>  nature. It just so happens that this is the first one with a
> Doug>  recent kernel to give useful data, useful enough to post it and
> Doug>  seek some advice on the subject:
>
> kernel 2.6.34 is still pretty old, and there have been lots of NFS
> fixes.  Can you upgrade to something newer as a test?  Also, what
> distro are you using?
>
> Is this an NFS client or the NFS server which is crapping out?  More
> details please...
>
>
It wasn't very old when we started testing it to resolve further NFS 
problems about 6 weeks ago. It takes a while to get through the 
necessary regressions to make sure things are generally ok before 
getting comfortable with a rollout to more than a couple nodes. The 
problems we experience are more of a statistical nature across nodes, so 
we don't usually experience them until we have some mass of upgraded nodes.

We checked through the changelists and didn't see anything that stood 
out as "ah ha, that's the problem". Most of the updates seemed to not 
mention NFS at all. Do you have one a particular issue/patch in mind?

This is a NFS client mounting a server elsewhere. The ps listing shows 
several stuck mount commands, which is another symptom of the general 
issue. Let me know what else. Certainly it's possible to try another, 
new kernel, but then I'll be posting about .36.1 in about 6-9 weeks and 
chances are that it will be considered old. :\

Distro is Centos5.4 with updates. kernel is from kernel.org

