Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1AYIE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:04:59 -0500
Received: from b.relay.invitel.net ([62.77.203.4]:51337 "EHLO
	b.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1AYIE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:04:57 -0500
Date: Tue, 25 Jan 2011 09:04:51 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 2/4 v4] video, sm501: add edid and commandline support
In-reply-to: <20110125075104.GJ11673@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Reply-to: hs@denx.de
Message-id: <4D3E8423.1090106@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1295863047-11131-1-git-send-email-hs@denx.de>
 <20110125075104.GJ11673@linux-sh.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

Paul Mundt wrote:
> On Mon, Jan 24, 2011 at 10:57:27AM +0100, Heiko Schocher wrote:
>> @@ -1884,7 +1935,6 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
>>  
>>  	if (info->pdata == NULL) {
>>  		dev_info(dev, "using default configuration data\n");
>> -		info->pdata = &sm501fb_def_pdata;
>>  	}
>>  
>>  	/* probe for the presence of each panel */
> 
> I assume this is accidental? I don't see how you're compensating for this
> in any of the other patches at least, as it's orthogonal from the default
> mode settings.

Seems so, rework this too, thanks!

bye,
heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
