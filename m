Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2GFIMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:12:12 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:43769 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802Ab2GFIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:12:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkNAAGd9k9bdWOb/2dsb2JhbABFrnsiiBuBB4IYAQEEAScLAQUdIwEFCwsYCRYPCQMCAQIBRQYNAQcBAYgCCbpCgkGIeIYmA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="539373473"
Message-ID: <4FF69DD3.9060009@igalia.com>
Date: Fri, 06 Jul 2012 10:12:03 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/19] Staging: xgifb: Rework conditions in XGI_SetLockRegs().
References: <cover.1341498465.git.magomez@igalia.com> <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com> <20120705180034.GC4519@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20120705180034.GC4519@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Thu, Jul 05, 2012 at 04:45:58PM +0200, Miguel Gómez wrote:
>> +		if ((pVBInfo->VBType & VB_SIS301LV) &&
>> +		    !(pVBInfo->TVInfo & TVSetHiVision)) {
>> +			if ((pVBInfo->TVInfo & TVSimuMode) &&
>> +			    (pVBInfo->TVInfo & TVSetPAL)) {
>> +				if (pVBInfo->VBType & VB_SIS301LV) {
>> +					if (!(pVBInfo->TVInfo &
>> +					      (TVSetYPbPr525p |
>> +					       TVSetYPbPr750p |
>> +					       TVSetHiVision)))
>> +						tempbx += 40;
>> +				} else {
>> +					tempbx += 40;
>
> I think this could be simplified even more - both branches end up doing
> the same?!

I'll give it a look again :)

Regards!


-- 
Miguel Gómez
Igalia - http://www.igalia.com


