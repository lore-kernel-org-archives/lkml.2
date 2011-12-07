Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab1LGVfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:35:32 -0500
Received: from li271-223.members.linode.com ([178.79.152.223]:59698 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366Ab1LGVfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:35:30 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Dec 2011 16:35:30 EST
Message-ID: <4EDFD9B8.1050300@mleia.com>
Date: Wed, 07 Dec 2011 23:25:12 +0200
From: Vladimir Zapolskiy <vz@mleia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>
Subject: Re: RFC: bq2415x_charger driver
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <1677656.4d3iQHNZjX@pali-elitebook>
In-Reply-To: <1677656.4d3iQHNZjX@pali-elitebook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20111207_212603_439423_B55BB9FC 
X-CRM114-Status: UNSURE (   9.80  )
X-CRM114-Notice: Please train this message. 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On 07.12.2011 23:03, Pali Rohár wrote:
> Hello,
>
> I'm sending preview of my implementation of bq2415x charger driver. Now all
> code is in one kernel module bq2415x_charger which has more interfaces
> (power_supply, sysfs, regulator). It is still unfinished, missing more bq2415x
> configuration like sysfs entires for boost, voltages or platform hooks (e.g.
> rx51 isp1704). This driver will have similar sysfs interface as in Joerg
> Reisenweber spec http://maemo.cloud-7.de/bq24150-sysnode.spec.txt . Driver
> should be replacemnt for Nokia N900 proprietary charging program BME. I was
> inspirated by driver bq27x00_battery and other bq2415x implementaton by
> Aliaksei Katovich and Felipe Contreras.
>
> Please comment implementation and write what should be added or modified in
> driver (it is still not complete).
>

There are well defined policies regarding patch review in the Linux 
kernel mailing lists. I encourage you to take a look at 
http://felipec.wordpress.com/2009/10/25/git-send-email-tricks/

-- 
With best wishes,
Vladimir
