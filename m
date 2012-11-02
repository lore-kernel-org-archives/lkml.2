Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725Ab2KBDyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 23:54:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56431 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762667Ab2KBDyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10ipvmVTEV_e_8+q-xLksVbBaPqWWDfc8H+W8KUPohDLA@mail.gmail.com>
References: <5064790E.4000207@cs.tu-berlin.de> <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
 <5065B909.1060907@cs.tu-berlin.de> <CAPXgP12v0aNtUnhKep3QiJwZYAp=NHebHVfS9N35V2EOSmAufg@mail.gmail.com>
 <CAPXgP13GCsooDtbor9_OvyDCZjPARL_On_cBtEoxTUWnVsBpvw@mail.gmail.com>
 <50732F8A.9090109@cs.tu-berlin.de> <CAPXgP10ipvmVTEV_e_8+q-xLksVbBaPqWWDfc8H+W8KUPohDLA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 2 Nov 2012 04:53:58 +0100
Message-ID: <CAPXgP13+DWxdU23Z45tLj0H+kjGL_QCi-wYs_LrYypxQVqPndw@mail.gmail.com>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 9:56 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Mon, Oct 8, 2012 at 9:54 PM, "Jan H. Schönherr"

>>> Jan,
>>> any updates, did you try something else?
>>> Or should we merge the first version for now?
>>
>> I'm working on it, though I cannot spend as much time as I want. :)
>>
>> My current version does mostly well for race-printk()s, now. But
>> there's still one issue to resolve and some polishing to do.
>>
>> If we can afford to wait a little longer, we might get a nicer
>> solution (and avoid a possible mostly-revert later).
>
> Sure, no hurry, I was just going through my TODO emails. :)

My TODO is nagging me again. :)

Any updates? No problems if not, but we should merge the current
version then, I think.

Thanks,
Kay
