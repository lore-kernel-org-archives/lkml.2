Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1K2MoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:44:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1K2MoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:44:08 -0500
Date: Tue, 29 Nov 2011 13:44:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Subject: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111129124406.GB4043@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111129123156.GA4043@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129123156.GA4043@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 13:31:56, Michal Hocko wrote:
> On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
[...]
> > $ grep . -r /sys/devices/system/cpu/cpuidle/
> > /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> > /sys/devices/system/cpu/cpuidle/current_governor_ro:menu

Could you try with acpi_idle driver?
echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
