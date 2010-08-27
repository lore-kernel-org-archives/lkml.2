Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0H0Vc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:32:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42982 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0H0VcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=SpL1sZ7HdXKAU2KzOfutn2TvnZuMkhBgPEy9dNwszug1KwEkgXudmSv82vmip33WZu
         GzmoTbiv3OuPUMl034olI+x04wofigz14IZW025aIHyWNmCLSdJdjhDMwVofMqaxJiDj
         fda8l3tpKdeBjc40yFpl9SEGMz3UOj6NuwmsA=
MIME-Version: 1.0
In-Reply-To: <4C7824F2.1050709@mandriva.org>
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com>
 <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com>
 <4C7824F2.1050709@mandriva.org>
From: Matteo Croce <matteo@openwrt.org>
Date: Fri, 27 Aug 2010 23:32:04 +0200
X-Google-Sender-Auth: 0MM1yS6inhWdyv3xiYBXgILezVI
Message-ID: <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
To: Thomas Backlund <tmb@mandriva.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Natale Vinto <ebballon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can I ignore the return value when I expect val to be non zero?
the doc says: "On error, the variable @x is set to zero."

On Fri, Aug 27, 2010 at 10:49 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> 27.08.2010 23:15, Matteo Croce skrev:
>>
>> On Fri, Aug 27, 2010 at 8:48 PM, H. Peter Anvin<hpa@zytor.com>  wrote:
>>>
>>> You're doing user-space references without get_user().
>>>
>>>        -hpa
>>>
>>> --
>>> H. Peter Anvin, Intel Open Source Technology Center
>>> I work for Intel.  I don't speak on their behalf.
>>>
>>>
>>
>> Here with get_user.
>> I CC Natale which is my beta tester, he have some Alix boards running
>> 24/24
>> with my patch
>>
>> --- a/arch/x86/kernel/Makefile  2010-08-27 19:42:01.795858001 +0200
>> +++ b/arch/x86/kernel/Makefile  2010-08-27 19:42:12.525858001 +0200
>> @@ -88,6 +88,8 @@
>>  obj-$(CONFIG_APB_TIMER)               += apb_timer.o
>>
>>  obj-$(CONFIG_K8_NB)           += k8.o
>> +obj-$(CONFIG_GEODE_NOPL)       += nopl_emu.o
>> +obj-$(CONFIG_GEODE_NOPL)       += nopl_emu.o
>
> Same line added twice...
>
> --
> Thomas
>



-- 
Matteo Croce
OpenWrt developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) ------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
