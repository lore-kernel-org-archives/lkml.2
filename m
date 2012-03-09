Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2CIIRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:17:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CIIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:17:14 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <CAJ0PZbQSuG2sJngV+MzaveWvvQZM=bm_GxB_725PNv0zAx+H5A@mail.gmail.com>
References: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
	<1331096521-26026-1-git-send-email-myungjoo.ham@samsung.com>
	<201203071002.40296.rjw@sisk.pl>
	<CAJ0PZbQSuG2sJngV+MzaveWvvQZM=bm_GxB_725PNv0zAx+H5A@mail.gmail.com>
Date: Fri, 9 Mar 2012 17:17:13 +0900
X-Google-Sender-Auth: 0mJTMhhWrGye6x_vm12qqmEaMSI
Message-ID: <CAJ0PZbRGv2kAMZfTSzt-zjNeN6WBQ195ktXbUfmwFGOTBVobCA@mail.gmail.com>
Subject: Re: [PATCH v3] PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        linux-pm@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 6:36 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> 2012/3/7 Rafael J. Wysocki <rjw@sisk.pl>:
>> Hi,
>>
>> Can you please post all of your outstanding PM-related patches that
>> you want me to look at in one series, so that they appear in context?
>>
>> I'm struggling to understand what you need all those changes for.
>>
>
> Hello Rafael,
>
>
> I've put the patches at
>
> - devfreq patches (based on your pm-devfreq branch)
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next
>
> - pm-qos patches (based on your pm-qos branch)
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/pm_qos-for-next
>
>
> - In order to help understand, all related patches are at (do not pull
> from here, please)
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq
> devfreq patches + pm-qos patches + cpufreq patches combined. (based on
> Linux 3.3-rc6 + some test patches.)
> However, it does not include recent PM-QoS patches in pm-qos branch,
> so the patches are not recent and different from the above. So please
> do not pull from here to your branches.
>

Hi Rafael,


Here goes to-be-pulled branches for linux-pm.git of yours (pm-devfreq,
pm-qos); they have some updates since last submissions (like those
mentioned by Mike)
Please use the following addresses if you feel fine for them to be pulled.


Cheers!
MyungJoo.

-------- PM / devfreq (fitted for pm-devfreq branch) ----------
The following changes since commit e4c9d8efe6bdc844071d68960dfa2003c5cf6449:

  Merge branch 'devfreq-for-next' of
git://git.infradead.org/users/kmpark/linux-samsung into pm-devfreq
(2012-01-25 00:02:08 +0100)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung devfreq-for-next

GITWEB: http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/devfreq-for-next

MyungJoo Ham (2):
      PM / devfreq: add PM QoS support
      PM / devfreq: add relation of recommended frequency.

 drivers/devfreq/devfreq.c     |  193 +++++++++++++++++++++++++++++++++++++++--
 drivers/devfreq/exynos4_bus.c |   14 ++-
 include/linux/devfreq.h       |   53 +++++++++++-
 3 files changed, 245 insertions(+), 15 deletions(-)



-------- PM / QoS (fitted for pm-qos branch) ----------
The following changes since commit a9b542ee607a8afafa9447292394959fc84ea650:

  PM / QoS: unconditionally build the feature (2012-02-13 16:23:42 +0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung pm_qos-for-next

GITWEB: http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/pm_qos-for-next

MyungJoo Ham (2):
      PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
      PM / QoS: add pm_qos_update_request_timeout API

 include/linux/pm_qos.h |    8 +++++
 kernel/power/qos.c     |   81 +++++++++++++++++++++++++++++++++++++++++++++++-




-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
