Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2EBIAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:00:44 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2857 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2EBIAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:00:42 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4FA0E962.7040402@broadcom.com>
Date: Wed, 2 May 2012 09:59:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
cc: "Sedat Dilek" <sedat.dilek@googlemail.com>,
        "Lennert Buytenhek" <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        "Jim Cromie" <jim.cromie@gmail.com>,
        "Ben Hutchings" <ben@decadent.org.uk>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Xose Vazquez Perez" <xose.vazquez@gmail.com>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
References: <20120427094637.GV3157@wantstofly.org>
 <CA+icZUXNZ=exTnR=OgD_9bpt_0s-KnR+v-K6u+XzQr4HBoTQHQ@mail.gmail.com>
 <20120427095842.GW3157@wantstofly.org>
 <CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
 <20120427101732.GX3157@wantstofly.org>
 <CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
 <CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
 <20120427185809.GZ3157@wantstofly.org>
 <CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
 <CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
 <20120501125102.GN3157@wantstofly.org>
 <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
In-Reply-To: <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
X-TMWD-Spam-Summary: TS=20120502080045; ID=1; SEV=2.3.1;
 DFV=B2012050208; IFV=NA; AIF=B2012050208; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413039303230342E34464130453941342E303037332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2012050208_5.03.0010
X-WSS-ID: 63BE36273E026206695-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 03:54 PM, Sedat Dilek wrote:
> On Tue, May 1, 2012 at 2:51 PM, Lennert Buytenhek
> <buytenh@wantstofly.org>  wrote:
>> On Sun, Apr 29, 2012 at 12:25:21AM +0200, Sedat Dilek wrote:
>>
>>>> On 1st sight, logs look fine:
>>>>
>>>> [21:52:52]<lautriv>  [    6.050967] ieee80211 phy0: 88w8361p v4,
>>>> 00173f3bdde3, STA firmware 2.1.4.25
>>>>
>>>> But WLAN connection is not that fast and stable as lautriv reports
>>>> (several abnormalities were observed).
>>>>
>>>> I requested a tarball which includes:
>>>> * dmesg (Linux-3.3.3)
>>>> * e_n_a (/etc/network/interfaces)
>>>> * ifconfig output
>>>> * iwconfig output
>>>> * iw_phy output
>>>> * ps_axu (WPA) output
>>>>
>>>> lautriv will be so kind to be around on #linux-wireless/Freenode the
>>>> next days (UTC+2: German/Swiss local-time).
>>>> Just ping him.
>>>>
>>>> Hope you have fun, together!
>>>>
>>>> - Sedat -
>>>
>>> A new tarball from lautriv with same outputs as before, but now tested
>>> with Linux-3.4-rc4.
>
> [ CC hauke (OpenWrt) and Ben Hutchings (linux-firmware maintainer) ]
>
>> The output looks good enough for me to ACK adding the PCI ID.
>>
>> Can the firmware being used here be submitted to the linux-firmware
>> git tree?
>
> I can't say much about the firmware [1] inclusion or the procedure of
> it into linux-firmware [2].
> Maybe, Ben can explain the procedure and what has to be considered
> before inclusion in linux-firmware.
> The original firmware and helper images were extracted from a Netgear
> Windows driver [1].
>
>  From what I read in the OpenWrt forum posting [3]: You wanted to care
> for inclusion:
>
> "Firmware isn't included in the kernel tree anymore, there's the
> linux-firmware git tree for that these days. I will contact some
> people at Marvell to ask whether 8361P firmware can be included
> there."

Basically, all firmware in linux-firmware repository should be 
accompanied with license information. Also you are signing off the patch 
to add the firmware to the repository so you are bound to the 
Developer's Certificate of Origin 1.1 in [1]. Having the firmware 
extracted from a windows driver does not fall under that statement, 
unless Marvell is ok with its redistribution. Recently a patch was 
submitted for a README in the linux-firmware repository about the 
process. It must be a binary patch. Easiest way is to use 'git 
format-patch -B'.

Gr. AvS

[1] http://lxr.linux.no/linux+v3.3.4/Documentation/SubmittingPatches
[2] https://lkml.org/lkml/2012/4/21/177

