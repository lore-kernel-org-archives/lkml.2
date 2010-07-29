Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0G2OfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595Ab0G2OfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:35:21 -0400
Message-ID: <4C5191A3.9070303@redhat.com>
Date: Thu, 29 Jul 2010 16:35:15 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org,
        kzak@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com>
In-Reply-To: <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 04:22 PM, Kay Sievers wrote:
>> First 8 loop devices are registered always (without backing file),
>> so you have wait for change event initiated from fd set ioctl anyway...
>> (backing file attribute is empty in that case)
> 
> Ah, so we are sure, we always get a 'change' event, and before that,
> none of these values are ever useful to read? I mean, there will not
> be attributes that are interesting during an 'add' event?

I think it was already that way for all loop block devices...

See loop block devices registered during module init
(up to max_loop - which is 8 by default) and later configured by losetup.

Milan
