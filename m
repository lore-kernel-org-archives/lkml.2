Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0LSUss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:48:48 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44700 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab0LSUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MY9xNfxtbiPq6hE+9rncRL35mJ+yH2PFSSWfyp/XH/PbbXiSqOgD7Su924OMPvLCFi
         uOZOe+1srFpOXBGtUwsL/Hkk3vXG4nDOSXpuRstD9mWV8yc627gKiYWw/4HAfSpsHYXp
         KvEc5Xl7DdkzOaZEX/dHZfWhC5SKHeN1VnN74=
MIME-Version: 1.0
In-Reply-To: <20101209153634.GQ8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
	<1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
	<20101209142912.GM8884@sortiz-mobl>
	<33A307AF30D7BF4F811B1568FE7A9B18047C7D405F@EXDCVYMBSTM006.EQ1STM.local>
	<20101209153634.GQ8884@sortiz-mobl>
Date: Sun, 19 Dec 2010 21:48:46 +0100
Message-ID: <AANLkTikG7CY9hcuSy6+na+xrjbJYdKE3tRysT0FKw5kD@mail.gmail.com>
Subject: Re: [PATCH 01/20] mfd/ab8500: remove spi support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/9 Samuel Ortiz <sameo@linux.intel.com>:

>> [Sundar]
>> >> Since the Ab8500 v1.0, the SPI support is deprecated on the HW.
>> >I'm fine with that, but you really don't want to be able to support pre 1.0
>> >devices ?
>>
>> AFAIK, there aren't active pieces of those outside STE :)
> Ok, that's a good reason. Please add my:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

This better be merged through the MFD tree. It touches a line in
the Makefile that has been changed since, the fixup is trivial but
it's orthogonal to the stuff I have in ux500-core anyway so Sam,
can you merge this into MFD?

(The other patch to remove the platform data for SPI mode
is in my ux500-core git already.)

Yours,
Linus Walleij
