Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1DSH0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:26:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58389 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1DSH0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TLn8wNoMa4kbd0HBeIaj+1lTNcsW8QLkHqyxtA+/yzVLu07o8Jrx92rO5tkooLIOq0
         pZFGNej9eH7f80cFOvlK+I5uJ5sDn4JSD18NCxlINfcu6hXgy42XMkTfynSfwCHJzm9E
         9gXo+SO94W9g1g5JnITZDjMM/x2xpeTRMI9vA=
MIME-Version: 1.0
In-Reply-To: <BANLkTika_0Xeex3+gsjupBdajSF7BPNPnw@mail.gmail.com>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
	<BANLkTingpBu6Xnpd8QdGX7LfUb3UDKj59w@mail.gmail.com>
	<BANLkTika_0Xeex3+gsjupBdajSF7BPNPnw@mail.gmail.com>
Date: Tue, 19 Apr 2011 15:26:32 +0800
Message-ID: <BANLkTinLz1Yf_mmiRuxDKm7XW4zM98MCtQ@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
From: wanlong gao <wanlong.gao@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/11, Hui Zhu <teawater@gmail.com> wrote:
> I don't think so.
>
> I am in x86_32 and x86_64.
>
> Thanks,
> Hui
So, you can copy your config file to the mail list , maybe some logs .
It will be more helpful to your issue .

Thanks
Wanlong
>
> On Tue, Apr 19, 2011 at 11:05, Wanlong Gao <wanlong.gao@gmail.com> wrote:
>> On 4/19/11, Hui Zhu <teawater@gmail.com> wrote:
>>> Cannot connect to any outside devices through bluetooth.
>>>
>>> And I think this is not a bug of low level driver.  Because both my
>>> laptop and a usb bluetooth card cannot work.
>>>
>>> Thanks,
>>> Hui
>> Maybe this patch can fix ?
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/bluetooth-fix-build-warnings-on-defconfigs.patch
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>


-- 
Best regards
Wanlong Gao
