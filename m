Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0IXSl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:41:27 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45757 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753645Ab0IXSl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:41:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qoQMDBZ1y2/AjrayQcZ/sMEymWInVuBPl3kKYrx5zqKNPp9uir0Tcfn4HHKTXeOVfdKcmsWUURuRXxcN/Bo9TuGhZSZfS6DdimVT9Ml7CSWPrptlAozutXdmvMnKLf7x;
Date: Fri, 24 Sep 2010 11:41:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
Message-ID: <20100924114122.4bfce00e@jbarnes-desktop>
In-Reply-To: <201009161803.10531.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009141529.53179.anarsoul@gmail.com>
	<20100914224111.GA14467@sucs.org>
	<201009161803.10531.anarsoul@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 18:03:04 +0300
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> В сообщении от 15 of September 2010 01:41:11 автор Sitsofe Wheeler написал:
> > > >     processor.max_cstate=2
> > > 
> > > Nope, it doesn't work with max_cstate=2
> > 
> > Perhaps intel_idle is being used? Any mention of it in dmesg?
> 
> Sitsofe, maybe you misunderstood me, I mean with max_cstate=1 graphics is 
> smooth, with higher values (i.e. max_cstate=2) graphics is jerky.
> 
> Btw, Jesse, any comments/solutions/workarounds except one with 
> processor.max_cstate=1 in kernel commandline? Should I file a bug on fdo 
> bugzilla?

FDO bug for this is https://bugs.freedesktop.org/show_bug.cgi?id=30364.

I still don't have a root cause, but at least we have a workaround.

-- 
Jesse Barnes, Intel Open Source Technology Center
