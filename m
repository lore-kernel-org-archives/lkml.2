Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1CPXHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:07:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49758 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CPXHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=T3bzE7pqIbld0zA51MQNBUf6LLWkPoHIrNLU5/7FekghLPuVo0FS6vRvGFL5giBmpr
         ZqMP/XZVrPhL/pe5YHrnyqTmhBbYxYQcmMWm7zlA9gQllkewF7/qWb9omKKost++spm+
         6KTP98cBB5J3OWW8ZAMY+9+T0tB/NGzkU7qg4=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [b43] usb device disconnects automatically after 1s
Date: Thu, 17 Mar 2011 01:06:58 +0200
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <201103170018.32061.mihai.dontu@gmail.com> <201103170022.24290.mihai.dontu@gmail.com> <AANLkTi=-B0e4VT_v+F23Q+hG_zn=JnVbmVHnFpETVrZu@mail.gmail.com>
In-Reply-To: <AANLkTi=-B0e4VT_v+F23Q+hG_zn=JnVbmVHnFpETVrZu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103170106.58746.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011 00:35:02 Rafał Miłecki wrote:
> 2011/3/16 Mihai Donțu <mihai.dontu@gmail.com>:
> > Added linux-usb and linux-wireless to CC.
> > 
> > On Thursday 17 March 2011 00:18:31 Mihai Donțu wrote:
> >> Hi,
> >> 
> >> I have just upgraded to 2.6.38 and discovered that I can't use my
> >> wireless device (BCM4312 802.11a/b/g). I press Fn + F2, the bluetooth
> >> led lights and after a second it turns off by itself. In dmesg I'm
> >> seeing the following:
> >> 
> >> [   88.167212] usb 1-2.2: new full speed USB device using ehci_hcd and
> >> address 5
> >> [   88.782330] usb 1-2.2: USB disconnect, address 5
> >> 
> >> I switched to 2.6.37 until I'll have some time to bisect this. In the
> >> mean time I have attached the output of lspci, interrupts and dmesg.
> 
> I suspect it's WMI related. What is your machine?

It's a Dell Latitude D520 but I can't find a link with full specs (in 
English).

> Please check:
> https://bugzilla.kernel.org/show_bug.cgi?id=31002
> http://comments.gmane.org/gmane.linux.acpi.devel/49577
> 
> I can't help you more, I just noticed such a issue reported on ACPI
> ML, you have to dig into this yourself (or someone else may help you).

Thanks for the links. I'll see if I can get anywhere from there.

-- 
Mihai Donțu
