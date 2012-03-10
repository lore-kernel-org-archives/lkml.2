Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2CJWSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:18:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2CJWSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:18:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v3] PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
Date: Sat, 10 Mar 2012 23:22:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        linux-pm@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
References: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06> <CAJ0PZbQSuG2sJngV+MzaveWvvQZM=bm_GxB_725PNv0zAx+H5A@mail.gmail.com> <CAJ0PZbRGv2kAMZfTSzt-zjNeN6WBQ195ktXbUfmwFGOTBVobCA@mail.gmail.com>
In-Reply-To: <CAJ0PZbRGv2kAMZfTSzt-zjNeN6WBQ195ktXbUfmwFGOTBVobCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203102322.19875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, March 09, 2012, MyungJoo Ham wrote:
> On Wed, Mar 7, 2012 at 6:36 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> > 2012/3/7 Rafael J. Wysocki <rjw@sisk.pl>:
[...]
> Hi Rafael,
> 
> 
> Here goes to-be-pulled branches for linux-pm.git of yours (pm-devfreq,
> pm-qos); they have some updates since last submissions (like those
> mentioned by Mike)
> Please use the following addresses if you feel fine for them to be pulled.
> 
> 
> Cheers!
> MyungJoo.
> 
> -------- PM / devfreq (fitted for pm-devfreq branch) ----------
> The following changes since commit e4c9d8efe6bdc844071d68960dfa2003c5cf6449:
> 
>   Merge branch 'devfreq-for-next' of
> git://git.infradead.org/users/kmpark/linux-samsung into pm-devfreq
> (2012-01-25 00:02:08 +0100)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/kmpark/linux-samsung devfreq-for-next
> 
> GITWEB: http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next
> 
> MyungJoo Ham (2):
>       PM / devfreq: add PM QoS support
>       PM / devfreq: add relation of recommended frequency.

This patch I'm fine whith and I can either take it as a standalone patch
or pull it from your tree if you put it into a separate branch for me.

The previous one, however, I'm not entirely comfortable with and I'd like
to discuss it in more detail.  Can you please post it for discussion?

>  drivers/devfreq/devfreq.c     |  193 +++++++++++++++++++++++++++++++++++++++--
>  drivers/devfreq/exynos4_bus.c |   14 ++-
>  include/linux/devfreq.h       |   53 +++++++++++-
>  3 files changed, 245 insertions(+), 15 deletions(-)
> 
> 
> 
> -------- PM / QoS (fitted for pm-qos branch) ----------
> The following changes since commit a9b542ee607a8afafa9447292394959fc84ea650:
> 
>   PM / QoS: unconditionally build the feature (2012-02-13 16:23:42 +0100)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-samsung pm_qos-for-next
> 
> GITWEB: http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/pm_qos-for-next
> 
> MyungJoo Ham (2):
>       PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
>       PM / QoS: add pm_qos_update_request_timeout API

I'd prefer all discussions to settle down before pulling these two.

Thanks,
Rafael
