Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161581Ab2COVRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:17:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49523 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161563Ab2COVR0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMFpKOjymX4N-w=cKMUaM6k3xBnN_SYVk9eDBhi37xjT4D0YWQ@mail.gmail.com>
References: <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
	<CAEnQRZBDxB5Vb7XTFKmdrvQOcWKQU0SWO4HExvDmFbEv_AMnQw@mail.gmail.com>
	<0F08A04750B6BE499D6FAC390A6128A231758C32@DBDE01.ent.ti.com>
	<CAMFpKOjymX4N-w=cKMUaM6k3xBnN_SYVk9eDBhi37xjT4D0YWQ@mail.gmail.com>
Date: Thu, 15 Mar 2012 23:17:25 +0200
Message-ID: <CAMFpKOjphDX0HbaReZCNHtux=j1LSpEK6nU3thddqFUHXUCiuA@mail.gmail.com>
Subject: Re: [PATCH] ti-st: Enhange logging for Shared Transport - TI driver
From: Alexandra Sava <alexandrasava18@gmail.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Daniel Baluta <daniel.baluta@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mgherzan@gmail.com" <mgherzan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 March 2012 23:10, Alexandra Sava <alexandrasava18@gmail.com> wrote:
> On 15 March 2012 22:29, Savoy, Pavan <pavan_savoy@ti.com> wrote:
>> Daniel Baluta wrote:
>>> Adding Greg's new email address.
>>>
>>> On Thu, Mar 15, 2012 at 8:26 PM,  <alexandrasava18@gmail.com> wrote:
>>>> From: Alexandra Sava <alexandrasava18@gmail.com>
>>>>
>>>> * added new module parameter named debug_mask to control displayed
>>>> messages verbosity
>>>> * the logging mechanism is enabled via CONFIG_TI_ST_DEBUG Kconfig
>>>> option
>>
>> Any specific reason you want to have this ? Custom logging ?
>> Also please fix the spelling in the subject line.
>>
>
> The logging for this driver is too verbose, and I thought it would be
> better to implement a configurable mechanism which can enable/disable
> the log messages (not only via the global CONFIG_DYNAMIC_DEBUG).
> So, I think there are two ways:

The logging for this driver is too verbose, and I thought it would be
better to implement a configurable mechanism which can enable/disable
the log messages (not only via the global CONFIG_DYNAMIC_DEBUG).
So, I think there are two ways:
	1. keep pr_debug but reduce the amount of messages
	2. make the logs configurabile via CONFIG_TI_SI_DEBUG


Alexandra
