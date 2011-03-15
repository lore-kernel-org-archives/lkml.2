Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1COLiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:38:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:56852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1COLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:38:22 -0400
Message-ID: <4D7F4F93.30505@infradead.org>
Date: Tue, 15 Mar 2011 08:37:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Oliver Neukum <oliver@neukum.org>, Jack Stone <jwjstone@fastmail.fm>
Subject: Re: [PATCH 1/2 v3] [media] dib0700: get rid of on-stack dma buffers
References: <201103061744.15946.oliver@neukum.org>	<1299433677-8269-1-git-send-email-florian@mickler.org>	<20110306185713.5b621e80@schatten.dmk.lab> <20110315093632.5fc9fb77@schatten.dmk.lab>
In-Reply-To: <20110315093632.5fc9fb77@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-03-2011 05:36, Florian Mickler escreveu:
> On Sun, 6 Mar 2011 18:57:13 +0100
> Florian Mickler <florian@mickler.org> wrote:
> 
>> On Sun,  6 Mar 2011 18:47:56 +0100
>> Florian Mickler <florian@mickler.org> wrote:
>>
>>
>>> +static void dib0700_disconnect(struct usb_interface *intf) {
>>
>>
>> That { should go on its own line... sorry ;-)
>>
>> If that patch is acceptable, I can resend with that fixed. 
>>
>> Regards,
>> Flo
> 
> 
> Hi Mauro, 
> 
> what about this patch? I have similar patches for the same problem in
> the other dvb-usb drivers in need of beeing fixed. Are you
> maintaining these drivers or should I find someone else to pick these
> up? 

I generally wait for the driver maintainer to review and test on their
hardware before applying on my tree.

I'll send you a few comments over the first patch on a separate email,
that also applies to the other patches.

Thanks,
Mauro.
