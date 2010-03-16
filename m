Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966445Ab0CPOuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:50:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:34915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966315Ab0CPOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:50:19 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Tue, 16 Mar 2010 15:50:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Robert =?iso-8859-15?q?Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <201003161159.24424.trenn@suse.de> <4B9F9361.6060208@linux.intel.com>
In-Reply-To: <4B9F9361.6060208@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003161550.18102.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010 15:19:13 Arjan van de Ven wrote:
> 
> > But something else...:
> > What exactly is the power tracer good for and what is it
> > capable of which cpufreq_stats is not capable to do?
> 
> look at timechart for example.....
> it's extremely useful to have this for us that do power tuning...
Currently even only a small subset of x86 ia supported, I can't see how
useful this is.

> cpufreq_stats is nice but not nearly good enough since you only get
> averages, not time behavior.
As said, try to hook it into cpufreq_stats.
Mark the cpufreq_stats sysfs interface deprecated, etc.

I like the idea of having one central trace utility, which probably
makes it easier for people to find such things.
But please do it properly and CC the cpufreq list in the future.

Still, as this is totally broken:
   - by design -> only one of a dozen cpufreq drivers is supported
   - by implementation -> wrong CPUs are tracked
please submit my patch and remove this again until a proper 
implementation is provided.

Thanks,

    Thomas
