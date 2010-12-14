Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0LNHqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 02:46:08 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:43818 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab0LNHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 02:46:07 -0500
Message-ID: <884C7BF624424621917562DB0C3E15E7@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>,
        "Richard Cochran" <richardcochran@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
References: <4C612AA4.5040100@dsn.okisemi.com> <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com> <20100817090637.GC3330@riccoc20.at.omicron.at> <201008171325.55761.arnd@arndb.de>
Subject: Re: [MeeGo-dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35
Date: Tue, 14 Dec 2010 16:46:03 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 17, 2010 8:25 PM, Arnd Bergmann wrote:
> Ohtake-san, Richard's code already contains an abstraction for multiple
> ieee1588 sources, which looks like it should perfectly fit your purposes.
> I don't see room for another user interface, so please try to integrate
> into version 5 of his ptp code.

We want to implement IEEE1588 driver for Intel EG20T PCH (Topcliff) using 
PTP core
according to you saying.
However, it seems PTP core module is not accepted by upstream.
How about your PTP status ?

Thanks,
---
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Richard Cochran" <richardcochran@gmail.com>
Cc: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>; <meego-dev@meego.com>; 
"LKML" <linux-kernel@vger.kernel.org>
Sent: Tuesday, August 17, 2010 8:25 PM
Subject: Re: [MeeGo-dev] [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 
driver to 2.6.35


> On Tuesday 17 August 2010, Richard Cochran wrote:
>> On Tue, Aug 17, 2010 at 04:12:45PM +0900, Masayuki Ohtake wrote:
>> > Intel Topcliff IEEE1588 device driver API is developed according to 
>> > Intel
>> > Tolapai 1588 device driver.
>> > Both APIs are the same.
>>
>> But what is the "Intel Tolapai 1588 device driver?"
>>
>> Is that a Linux driver?
>>
>> If so, where can I find it?
>
> I found it under
> http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=17182
>
> That driver was never submitted for inclusion anywhere, so it is not
> really relevant here. The APIs are similar, but not identical, most
> importantly they use a different ioctl command base number, but also
> some of the structures are laid out slightly differently.
>
> Ohtake-san, Richard's code already contains an abstraction for multiple
> ieee1588 sources, which looks like it should perfectly fit your purposes.
> I don't see room for another user interface, so please try to integrate
> into version 5 of his ptp code.
>
> Arnd
> 

