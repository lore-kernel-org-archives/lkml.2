Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0ESPd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:33:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0ESPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:33:26 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 4/4] omap: cpu: Power tracking support for cgroup cpuacct
Date: Wed, 19 May 2010 17:34:27 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.12-0.2-desktop; KDE/4.4.3; x86_64; ; )
Cc: Mike Chan <mike@android.com>,
       "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
       "menage@google.com" <menage@google.com>,
       "balbir@in.ibm.com" <balbir@in.ibm.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1274232620-23003-1-git-send-email-mike@android.com> <1274232620-23003-5-git-send-email-mike@android.com> <4BF3E367.5080906@ti.com>
In-Reply-To: <4BF3E367.5080906@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005191734.27887.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010 15:11:03 Nishanth Menon wrote:
> Mike Chan had written, on 05/18/2010 08:30 PM, the following:
> > Specify new power field in struct omap_opp, which is
> > power exported in milliWatt.
...
> > +		totalpower += cpuacct_freq[i] * mpu_opps[i + 1].power;
...
> > +	unsigned long power; /* power consumed running at OPP in 
milliWatts */
> 
> this conflicts with the OPP layer implementation. this structure will 
> disappear for good.
Ah yes, another question:
The power variable in struct omap_opp never gets initialized
with a sane value, something is wrong...

     Thomas
