Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0LWBq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:46:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0LWBq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:46:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lnk5sDUWIA/R0UAak9t5a+Lwu0jDrVtYj/HwiCfr1YzD+xNjt4agszgUdhpFyfaAjB
         HDccBZsAXxfqdrP40FZk9wViSzj2G+8bTSeW2MlYAvpyWpNkYFC8+Vw1VjeEtal6Iogy
         IuGbwTe7f8CgvXkZdTjPAKWPUZ4GvCtSwAX8I=
MIME-Version: 1.0
In-Reply-To: <20101222132534.GB26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
	<1292998991-26968-3-git-send-email-myungjoo.ham@samsung.com>
	<20101222132534.GB26306@opensource.wolfsonmicro.com>
Date: Thu, 23 Dec 2010 10:45:55 +0900
X-Google-Sender-Auth: pp0Q16R32azkwieatXU47yZ79J4
Message-ID: <AANLkTik7Bqzi3FhbQhqqTiJ2CVKfGX-rMPPyrURARsnX@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] MFD MAX8998/LP3974: Support LP3974 RTC
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 22, 2010 at 03:23:07PM +0900, MyungJoo Ham wrote:
>
>> before reading it. If the device name is "lp3974-regerr", the rtc driver
>> assumes that such delays are required. If the device name is "lp3974",
>> the rtc driver does not. Although we have not seen LP3974s without
>> requiring such delays, we assume that such LP3974s will be released
>> soon (or they have done so already) and they are supported by "lp3974".
>
> Might a bit of platform data not be a more robust way of passing this
> in?  If we use the device name then it'd be difficult to handle other
> issues in future.
>
> It's a shame the affected devices can't be identified at runtime :(
>

There should be a register showing "CHIP ID", which can be used to
identify revisions and makers (MAX8998 vs LP3974). However, it is not
written in their datasheet (at least in LP3974 Datasheet Revision 9),
and I have absolutely no information about their "later revisions" of
LP3974.

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
