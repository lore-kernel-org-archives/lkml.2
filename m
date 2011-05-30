Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1E3M16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:27:58 -0400
Received: from mx2.imt-systems.com ([89.146.219.34]:44048 "EHLO
	mx2.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1E3M15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:27:57 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 08:27:57 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 acsinet10.imt-systems.com p4UCMCgk010770
From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
To: Damien Wyart <damien.wyart@free.fr>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 30 May 2011 14:22:09 +0200
Subject: Re: Very high CPU load when idle with 3.0-rc1
Thread-Topic: Very high CPU load when idle with 3.0-rc1
Thread-Index: AcwekCO9oJG5dRY6RCyM6M9VYrnWWQAM/D2Q
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A87DF8E61F64@mail.corp.imt-systems.com>
References: <20110530055924.GA9169@brouette>
In-Reply-To: <20110530055924.GA9169@brouette>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Score: -0.811 () DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_PASS,T_RP_MATCHES_RCVD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/30 Damien Wyart <damien.wyart@free.fr>:
> Hi,
>
> Testing 3.0-rc1 on a core i7 (4 cores + HT), I get a load average of 9.0
> when idle. No process is shown running or in "D state" in htop. The box
> is behaving normal, no impression of lag or slowness.
>
> Not sure what other info to include, I guess this should be quite easy
> to reproduce.

Same problem here.

# uname -r
3.0.0-rc1
# uptime
14:18:39 up 30 min,  2 users,  load average: 10.00, 10.15, 9.68

Best regards,

Morten
