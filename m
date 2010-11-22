Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0KVOoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:44:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47481 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab0KVOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EJSEkway/By5Kr0XM28AUbhIgJhxsLFhreHdEwSkG6kePryd9rf2KANYhALmoWJoYP
         lgoBQbMfOWEeC4ERT5nLFp89JXm6YIFeI2YkwYU2E+jq7myLguV2sPAcOey5Ak/MRjIG
         2UONLthkdECNxmkl3Xk25pWTXPKqkl0tYceM4=
MIME-Version: 1.0
In-Reply-To: <4CEA54C9.4030300@infradead.org>
References: <AANLkTinTwyioFt2mGmetK=rfj-q_7hLBQ_FR_aE20FXZ@mail.gmail.com>
	<4CEA54C9.4030300@infradead.org>
Date: Mon, 22 Nov 2010 15:44:19 +0100
Message-ID: <AANLkTimvSC6q482W-Mrs9YoBPn1fh1yF9KXMJBdrVARb@mail.gmail.com>
Subject: Re: tvp5150 extension to tvp5151
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:32 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Hi Raffaele,
>
> Em 19-11-2010 16:26, Raffaele Recalcati escreveu:
>> I need to support fully tvp5151.
>> So I'm trying to understand your driver, that is ready for VBI and not
>> for video acquisition.
>> I also take sometimes a look at tvp514x.c, for instance trying to add
>> VIDIOC_ENUM_FMT and other ioctls.
>> I think we can move from tvp5150.c to tvp515x.c, maybe...
>> I don't think is good to have tvp51xx.c because tvp514x.c family is
>> more complex (more inputs...).
>> By now I'm using tvp5150.c with some modifications and video acquisition works.
>> I need to complete the support in order to have gstreamer fully running.
>> I'm working on 2.6.32, but I have planned to port it to mainline.
>
> Renaming it to tvp515x.c and adding support for tvp5051 seems a good way.
> With tvp5150, video acquisition works fine with several devices with em28xx,
> although we may need to add more video formats at the media bus, depending
> on what you're doing. I didn't test VBI support on it, because the devices
> I have are based on em28xx, and I didn't find any way to capture the VBI
> decoded packages and sent to userspace with that design. So, the basic stuff
> is there, but maybe some adjusts may be needed for VBI.
>
>> Do you have any suggestion for my work?
>
> The better is to submit the patches you have, for us to apply upstream.

Thx for your reply..
I have added many v4l2 support similar to tvp514x.
I need to test them, hoping they work.
When all we'll be ok I'll send patches.
So I go on renaming all strings from "tvp5150" to "tvp515x".

Thx,
Raffaele
