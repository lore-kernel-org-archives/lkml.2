Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1JXL4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:56:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46498 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1JXL4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:56:45 -0400
Date: Mon, 24 Oct 2011 19:56:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RFC] [PATCH -rt 5/5] cpufreq: get rid of
 get_online_cpus()/put_online_cpus()
Message-ID: <20111024115624.GB2635@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
 <1318762607-2261-6-git-send-email-yong.zhang0@gmail.com>
 <alpine.LFD.2.02.1110191110140.3240@ionos>
 <20111024024416.GB24581@zhy>
 <alpine.LFD.2.02.1110241123190.2642@ionos>
 <20111024113056.GA2635@zhy>
 <alpine.LFD.2.02.1110241343130.2633@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110241343130.2633@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 01:45:16PM +0200, Thomas Gleixner wrote:
> On Mon, 24 Oct 2011, Yong Zhang wrote:
> > On Mon, Oct 24, 2011 at 11:24:51AM +0200, Thomas Gleixner wrote:
> > > > No sure whether it's big issue or not.
> > > > Mind showing more about your concern?
> > > 
> > > This is probably not the only place which will run into that issue and
> > > I have not much interest to patch all those sites.
> > 
> > If so, I think that kind of violation has been caught in mainline,
> > because mainline has had CPU_DOWN_PREPARE called under
> > cpu_hotplug.lock, right?
> > 
> > Or am I missing something?
> 
> Hmm, no. I obviously forgot that I moved it in RT :(
> 
> So yes, it should be safe. Though the question is why cpufreq does not
> suffer from that that problem in mainline.

By this one: peter_zijlstra-fix-cpufreq.patch

Thanks,
Yong
