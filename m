Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab1INVDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:03:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34835 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab1INVDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110914074621.GA3582@polaris.bitmath.org>
References: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
 <1315029042-27513-2-git-send-email-martinez.javier@gmail.com>
 <20110913082448.GA5046@polaris.bitmath.org> <CAAwP0s0FvkzTUo5kAZE_pd_8u-znDvoLks74gf8+75cUF0aM2g@mail.gmail.com>
 <20110914074621.GA3582@polaris.bitmath.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 14 Sep 2011 23:03:22 +0200
Message-ID: <CAAwP0s2iWaDwAXiaHn110WahnbEhG43nnC_pJwC=539OB4vmmA@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 9:46 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>> Yes it is the right patch, or at least the patch I meant to send. The
>> staging version I send earlier didn't support multi-touch protocol
>> type A.
>
> I see - the cyttsp_xydata struct seems to be the old version,
> though. Any particular reason for that? Also, the similarity to the
> problem found here, https://lkml.org/lkml/2011/8/25/516, suggests your
> 16 tracking ids could be mapped directly to slots instead, using the
> example code. It ought to reduce the present patch significantly.
>
> Thanks,
> Henrik
>

Hello Henrik,

Thank you for your recommendations.

I didn't know that there was a newer version of cyttsp_xydata struct.
I thought I based my work on the last version of Cypress driver.
Didn't know about Dudley Du's work either. It seems that both drivers
are for the same device family.

I'll take a look at Dudley's patch-set and also contact him to join efforts.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
