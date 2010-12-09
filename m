Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0LIBUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:20:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38091 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0LIBUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NQDNPGcnwMWf/JA9FDjAdJqZ6A1kg0twh/BicvVgJ5P0DNk8+jZhrOf2Ivuc9PYZ9o
         SfBXpzFOVf1kaz5R7SQ0Hd92vtclDB2Jx8noGvNYbFHSyBR0q+nC2SsG+Z4mz1ktccHG
         exLgJgCzeV6jWWV1p2rJUlgckJiLRUTrsR9dY=
MIME-Version: 1.0
In-Reply-To: <4D002CE8.2060803@euromail.se>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
	<4CFFC3C2.1080905@canonical.com>
	<AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
	<20101208235805.GE15294@core.coreip.homeip.net>
	<4D002CE8.2060803@euromail.se>
Date: Wed, 8 Dec 2010 17:20:43 -0800
Message-ID: <AANLkTinzyNBT2u2QyFwpbJJDAPK1j5-tJZZzd8Q+eSMS@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add an envelope tool type
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 5:12 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>>>
>
>>>> Is it assumed that the envelop has only two touches comprising it? Or is
>>>> it any number of touches? If it's any number of touches, how does one
>>>> know how many touches it is?
>>>
>>> Those are good questions. Specifying how many touches are in the
>>> envelop makes sense. It also covers rectangle as a special case of
>>> envelop.
>>
>> I have a feeling that trying to accomodate non-rectangular, more than 2
>> point shapes without using native MT data is over-engineering the
>> problem... Do we have examples other than older generation Elantechs and
>> Synaptics that need envelope notion?
>>
>
>
> Those are the ones targeted so far. Maybe appletouch could be added to the list
> as well. I imagine all drivers will end up using zero, one and two envelope points.

What are the "points" here? Do you mean the points inside the envelope
or number of envelopes?

Ping
