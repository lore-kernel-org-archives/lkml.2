Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1AICjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 21:39:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47839 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1AICje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 21:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wN7tTYuHcFj7WD/JhT8LQBFZ0bO1W1ldX0oQT6Uc2qwGrfxbkHsXRQo4iWNTHydbcr
         zzjrTGDRTVl9pbKcwdZshu54h7nAItykbAhAZehUDJMIPkI6cvl+A22u6TbNs8LOHdiT
         nveh/xyTHZzbteRpOYXJxzT4lvOnR20XspNag=
MIME-Version: 1.0
In-Reply-To: <20110108115721.GB10971@elte.hu>
References: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
	<AANLkTinkxPSeWz1jev69quw+Nv+3JG0U6t2WE4cDkuxV@mail.gmail.com>
	<20110108115721.GB10971@elte.hu>
Date: Sun, 9 Jan 2011 10:39:32 +0800
Message-ID: <AANLkTinOi0n7qu++tr5kVkdSbAf-8-WYq7cUdY6XNpQ3@mail.gmail.com>
Subject: Re: [PATCH] replace ida in workqueue with page-sized buffer
From: Hillf Danton <dhillf@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 8, 2011 at 7:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> Hey Ingo
>>
>> Please take a glance at the patch for replacing ida in workqueue at
>>
>>        https://lkml.org/lkml/2010/12/18/35
>>
>
> Tejun is driving workqueues these days. (I've Cc:-ed him.)
>
> Thanks,
>
>        Ingo

Thank you Ingo.
Hillf
