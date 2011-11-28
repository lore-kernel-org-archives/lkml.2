Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1K1DsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:48:16 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:60757 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab1K1DsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:48:14 -0500
Message-ID: <4ED30398.6030505@st.com>
Date: Mon, 28 Nov 2011 09:14:24 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Munaut <tnt@246tNt.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Mark Miesfeld <mmiesfeld@amcc.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [PATCH] SATA/PATA: convert drivers/ata/* to use module_platform_driver()
References: <1322376266.2226.3.camel@phoenix> <4ED30351.7090809@st.com>
In-Reply-To: <4ED30351.7090809@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 9:13 AM, Viresh Kumar wrote:
> diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
>> index e8574bb..048589f 100644
>> --- a/drivers/ata/pata_arasan_cf.c
>> +++ b/drivers/ata/pata_arasan_cf.c
> 
> For SPEAr:
> 
> Acked-by: Viresh Kumar <viresh.kumar@st.com>

Oops!! I meant pata_arasan_cf, not SPEAr.

-- 
viresh
