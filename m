Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1K2MyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:54:19 -0500
Received: from smtprelay0100.b.hostedemail.com ([64.98.42.100]:32813 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395Ab1K2MyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:54:18 -0500
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,4b644c817c175539,d41d8cd98f00b204,t.artem@lycos.com,mhocko@suse.cz:pomac@vapor.com:linux-kernel@vger.kernel.org:rjw@sisk.pl:tino.keitel@tikei.de,RULES_HIT:152:355:379:541:582:599:601:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1676:1711:1714:1730:1747:1766:1792:2393:2553:2559:2562:3027:3138:3873:3876:4321:5007:6119:6261:7903:10004:10016:10400:11657:11658:11914:12043,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:1:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1674
Date: Tue, 29 Nov 2011 12:54:16 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: mhocko@suse.cz
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Message-ID: <1833322904.224056.1322571256185.JavaMail.mail@webmail07>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111129123156.GA4043@tiehlicka.suse.cz>
 <20111129124406.GB4043@tiehlicka.suse.cz>
Subject: Re: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU
 usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.36.231]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Nov 29, 2011, Michal Hocko  wrote: 
> 
> On Tue 29-11-11 13:31:56, Michal Hocko wrote:
> > On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> [...]
> > > $ grep . -r /sys/devices/system/cpu/cpuidle/
> > > /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> > > /sys/devices/system/cpu/cpuidle/current_governor_ro:menu
> 
> Could you try with acpi_idle driver?
> echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver

[root@localhost ~]# echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
-bash: /sys/devices/system/cpu/cpuidle/current_driver: Permission denied
