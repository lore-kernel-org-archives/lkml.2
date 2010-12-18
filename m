Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0LRAKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:10:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53164 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab0LRAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:10:20 -0500
Message-ID: <4D0BFB9E.9040404@oracle.com>
Date: Sat, 18 Dec 2010 08:09:02 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: [NETWORK] Firmware file for tehuti
References: <4D0B0B70.9050306@oracle.com> <1292594691.3136.840.camel@localhost>
In-Reply-To: <1292594691.3136.840.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> My first version of the patch to use request_firmware() used
> "tehuti/firmware.bin".  I then found Jaswinder's patch at
> <http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=e41f3e5f8c5110871e376a2566b8eea2932b813b>,
> which used the name "tehuti/bdx.bin".  For some reason I changed the
> name of the firmware file in my patch to match that, but not the code.
>

Thanks for the confirmation.
> Ben.
>


-- 
Oracle<http://www.oracle.com>
Joe Jin | Team Leader, Software Development | +8610.8278.6295
ORACLE | Linux and Virtualization
Incubator Building 2-A ZPark | Beijing China, 100094

