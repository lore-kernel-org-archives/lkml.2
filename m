Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0CVHFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:05:01 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:59760 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321Ab0CVHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:05:00 -0400
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
In-Reply-To: <4BA6BD0A.6030303@linux.intel.com>
References: <1268399863.3407.15.camel@localhost>
	 <201003182143.22929.trenn@suse.de> <1268985679.3395.47.camel@localhost>
	 <201003202237.57477.trenn@suse.de>  <4BA6BD0A.6030303@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 08:04:52 +0100
Message-ID: <1269241492.3485.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 21.03.2010, 17:42 -0700 schrieb Arjan van de Ven:
> On 3/20/2010 14:37, Thomas Renninger wrote:
> 
> > It also seem to be (hopefully) a minor feature for timechart, so this should
> > not hurt that much (yet).
> 
> It's actually a major feature for timechart, and one of the key things I and a bunch of others
> inside Intel use timechart for.
> 
It's a major feature for us too.
I suppose, the cpufreq_notify_transition calls are correct (meaning
being called for all related cpus) for every driver. So there's still
the option to include it in the POST_CHANGE section of this function.
Could this be okay for the both of you?


-- 
Robert Schoene
Technische Universitaet Dresden
Zentrum fuer Informationsdienste und Hochleistungsrechnen
01062 Dresden

Tel.: (0351) 463-42483, Fax: (0351) 463-37773
E-Mail: Robert.Schoene@tu-dresden.de

