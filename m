Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2KBWh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:37:26 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:52625 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2KBWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:37:24 -0400
Message-ID: <50944B16.8010201@cs.tu-berlin.de>
Date: Fri, 02 Nov 2012 23:37:10 +0100
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
References: <5064790E.4000207@cs.tu-berlin.de> <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de> <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com> <5065B909.1060907@cs.tu-berlin.de> <CAPXgP12v0aNtUnhKep3QiJwZYAp=NHebHVfS9N35V2EOSmAufg@mail.gmail.com> <CAPXgP13GCsooDtbor9_OvyDCZjPARL_On_cBtEoxTUWnVsBpvw@mail.gmail.com> <50732F8A.9090109@cs.tu-berlin.de> <CAPXgP10ipvmVTEV_e_8+q-xLksVbBaPqWWDfc8H+W8KUPohDLA@mail.gmail.com> <CAPXgP13+DWxdU23Z45tLj0H+kjGL_QCi-wYs_LrYypxQVqPndw@mail.gmail.com>
In-Reply-To: <CAPXgP13+DWxdU23Z45tLj0H+kjGL_QCi-wYs_LrYypxQVqPndw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.11.2012 04:53, schrieb Kay Sievers:
> On Mon, Oct 8, 2012 at 9:56 PM, Kay Sievers <kay@vrfy.org> wrote:
>> On Mon, Oct 8, 2012 at 9:54 PM, "Jan H. Schönherr"
> 
>>>> Jan,
>>>> any updates, did you try something else?
>>>> Or should we merge the first version for now?
>>>
>>> I'm working on it, though I cannot spend as much time as I want. :)
>>>
>>> My current version does mostly well for race-printk()s, now. But
>>> there's still one issue to resolve and some polishing to do.
>>>
>>> If we can afford to wait a little longer, we might get a nicer
>>> solution (and avoid a possible mostly-revert later).
>>
>> Sure, no hurry, I was just going through my TODO emails. :)
> 
> My TODO is nagging me again. :)
> 
> Any updates? No problems if not, but we should merge the current
> version then, I think.
> 

Then let's take the first version. :)

Thanks
Jan
