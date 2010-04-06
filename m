Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0DFQ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:57:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65510 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab0DFQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:57:46 -0400
Date: Tue, 6 Apr 2010 19:57:20 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Nishanth Menon <nm@ti.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "S, Venkatraman" <svenkatr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
 peformance.
Message-ID: <20100406165720.GA17916@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com>
 <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com>
 <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com>
 <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com>
 <20100405164839.GB17388@gandalf>
 <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com>
 <20100406050035.GA32537@gandalf>
 <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com>
 <20100406163211.GA29117@nokia.com>
 <4BBB6767.7010202@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4BBB6767.7010202@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Apr 2010 16:57:32.0104 (UTC) FILETIME=[3F900480:01CAD5AA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 06:55:03PM +0200, ext Nishanth Menon wrote:
>some reasons why i love switch statements ;) since I dont expect other
>than precisely 4 and 8 (do we expect 5,6,7 - i might be wrong).. but if
>it is so, wont the following be better?
>
>switch (mmc_slot(host).wires)
>{
>case 8:
>	mmc->caps |= MMC_CAP_8_BIT_DATA;
>	/* fall thru*/
>case 4:
>	mmc->caps |= MMC_CAP_4_BIT_DATA;
>		break;
>default:
>	WARN("bad width");
>}

I like that, but I remember Madhu (or someone else) saying he thinks 
it's less readable this way. Go figure...

-- 
balbi
