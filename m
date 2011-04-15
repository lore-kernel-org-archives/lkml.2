Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1DONVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:21:33 -0400
Received: from gmmr4.centrum.cz ([90.183.38.143]:57715 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1DONVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:21:32 -0400
To: "Mel Gorman" <mgorman@suse.de>
Subject: Re: Regression from 2.6.36
Date: Fri, 15 Apr 2011 15:21:30 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Changli Gao" <xiaosuo@gmail.com>,
        "Am?rico Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "Jiri Slaby" <jirislaby@gmail.com>
References: <1302178426.3357.34.camel@edumazet-laptop>	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>	 <1302190586.3357.45.camel@edumazet-laptop>	 <20110412154906.70829d60.akpm@linux-foundation.org>	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>	 <20110412183132.a854bffc.akpm@linux-foundation.org>	 <1302662256.2811.27.camel@edumazet-laptop>	 <20110413141600.28793661.akpm@linux-foundation.org>	 <20110414102501.GE11871@csn.ul.ie> <20110415115903.315DEAA1@pobox.sk>	 <20110415104700.GD22688@suse.de>  <20110415125651.68156745@pobox.sk>	 <1302866247.12428.25.camel@machina.109elm.lan>	 <20110415133644.12504ADB@pobox.sk> <1302872460.12428.27.camel@machina.109elm.lan>
In-Reply-To: <1302872460.12428.27.camel@machina.109elm.lan>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110415152130.AECAA367@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So it's really not necessary ? It would be better for us if you can go without it cos it means to run buggy kernel for one more day.

Which kernel versions will include this fix ?

Thank you very much!

azur



______________________________________________________________
> Od: "Mel Gorman" <mgorman@suse.de>
> Komu: azurIt <azurit@pobox.sk>
> Dátum: 15.04.2011 15:01
> Predmet: Re: Regression from 2.6.36
>
> CC: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Dumazet" <eric.dumazet@gmail.com>, "Changli Gao" <xiaosuo@gmail.com>, "Am?rico Wang" <xiyou.wangcong@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
>On Fri, 2011-04-15 at 13:36 +0200, azurIt wrote:
>> sysfs was already mounted:
>> 
>> # mount
>> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>> 
>> 
>> I have enabled all of the options you suggested and also CONFIG_DEBUG_FS ;) I will boot new kernel this night. Hope it won't degraded performance much..
>> 
>
>It's only for curiousity's sake. As you report the patch fixes the
>problem, it matches the theory that it's allocator latency. The script
>would confirm it for sure, but it's not a high priority.
>
>-- 
>Mel Gorman
>SUSE Labs
>
>
