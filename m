Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030746Ab2HQD3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:29:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43484 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030688Ab2HQD3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120816174019.GA10918@kroah.com>
References: <1344583783-12593-1-git-send-email-anish198519851985@gmail.com>
	<20120816174019.GA10918@kroah.com>
Date: Fri, 17 Aug 2012 08:59:04 +0530
Message-ID: <CAK7N6vpskT=nhBcvdBKopX_oySdH-j_7c62aB1Q5FxGxfjE3cg@mail.gmail.com>
Subject: Re: [PATCH] [PATCH V6]Extcon: adc_jack: adc-jack driver to support
 3.5 pi or simliar devices
From: anish singh <anish198519851985@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish.singh@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:10 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Aug 10, 2012 at 12:29:43AM -0700, anish kumar wrote:
>> From: anish kumar <anish198519851985@gmail.com>
>>
>> External connector devices that decides connection information based on
>> ADC values may use adc-jack device driver. The user simply needs to
>> provide a table of adc range and connection states. Then, extcon
>> framework will automatically notify others.
>
> This patch breaks the build:
>         ERROR: "extcon_cable_name" [drivers/extcon/extcon-adc-jack.ko] undefined!
>
> And, if you read the comment about extcon_cable_name, it says to not use
> it like you are trying to use it.
>
> So, care to fix this up?
Sorry Greg,I was on travel so couldn't fix it up.However soon I will be sending
a patch for this.Looks like we can remove the extcon_cable_name altogether
as it we are anyway getting it from platform data.
>
> thanks,
>
> greg k-h
