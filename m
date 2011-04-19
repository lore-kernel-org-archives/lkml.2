Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1DSPev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:34:51 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63500 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1DSPeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iRbQ089y3WkKHLgJE6aD1g34E6nA5FHTWgAJc5rYJXu7FvZy91xZlnpqSba/XWBgPJ
         T6p2IcgiNDymB8x5lDjlJ42W1an2Kqp/ex1b5kpppwbVmRSPCbNkLj2to+k/xaXOOrlS
         PeEk31NWbh7AgYTU5uAo9WV84io0j7vilc9Qo=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=-RnUyuC2VGuRix_J4KOx+9BhroQ@mail.gmail.com>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com> <BANLkTi=-RnUyuC2VGuRix_J4KOx+9BhroQ@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 19 Apr 2011 23:34:30 +0800
Message-ID: <BANLkTik67uGB-1q17JcTPnr_WjuNd_37gA@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you part is OK?

I think it will be very easy to reproduce.

Thanks,
Hui

On Tue, Apr 19, 2011 at 15:46, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Apr 19, 2011 at 10:53 AM, Hui Zhu <teawater@gmail.com> wrote:
>> Cannot connect to any outside devices through bluetooth.
>>
>> And I think this is not a bug of low level driver.  Because both my
>> laptop and a usb bluetooth card cannot work.
>
> Hi, please explain the "cannot work" in detail,
> Firstly check dmesg and hciconfig to see if there's anything wrong.
>
> --
> Regards
> dave
>
