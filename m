Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1L1CO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 21:14:26 -0500
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:60870 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab1L1COX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 21:14:23 -0500
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 21:14:22 EST
Message-ID: <4EFA779D.2070408@gmail.com>
Date: Wed, 28 Dec 2011 02:57:49 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>
CC: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com> <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana> <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana> <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com>
In-Reply-To: <4EFA7696.6060506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ziggo-spambar: ---
X-Ziggo-spamscore: -3.6
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FREEMAIL_FROM=0.5,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-12-11 02:53, Rene Herman wrote:

> On 28-12-11 02:28, Gustavo Padovan wrote:
>
>>> For some reason your adapter is returning here the same value of
>>> Read Local Features. I would say your device is broken. The only
>>> fix I have in mind now is throw away the device.
>>
>> Yes, I have one of these ISSC devices, it's completely broken
>> device.
>
> It worked well upto and including 2.6.29 though.

2.6.39, that is.

> This would seem to be the kind of thing other subsystems use quirk
> handling for. The device identifies itself as "1131:1004":
>
> Bus 002 Device 002: ID 1131:1004 Integrated System Solution Corp.
> Bluetooth Device
>
> Do you guys have infra-structure in place for adapter-specific (quirk)
> handling?
>
> Rene.
