Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0FCOOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:14:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37931 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0FCOOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QamKCjOASUmzBchnmJ1S+MnILWR0cl0ttk6uxgGzZN176EPEw8Ztw6YcHYBJ/ZDKvn
         XRjgEmmny3k75bJddFbzkq7Dsslpa9hrnf1a6y5QoRerEVaRhKXoxi3xq7a25+vCakF1
         h9zjAGQsObNgfUbcSLGEClaPFjcC6JHkjaWGc=
MIME-Version: 1.0
In-Reply-To: <20100603135031.GA9964@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<20100603075402.GA11093@oksana.dev.rtsoft.ru>
	<AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
	<AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
	<AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
	<20100603093923.GA25856@oksana.dev.rtsoft.ru>
	<AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
	<20100603131414.GA23520@oksana.dev.rtsoft.ru>
	<20100603132319.GA4889@oksana.dev.rtsoft.ru>
	<20100603135031.GA9964@oksana.dev.rtsoft.ru>
Date: Thu, 3 Jun 2010 22:13:57 +0800
Message-ID: <AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
> [...]
>> Oh. It seems I found it. It must be the module order loading
>> thing.
>>
>> Can you try the patch down below?
>
> OTOH... libahci is a link-time dependency. And the order doesn't
> matter here. So you should just have the libahci module in
> the initrd (actually, mkinitrd or whatever you use should
> have included this automatically).
>

Neither ahci nor libachi is automatically included in initrd..
Manually added ahci and libachi into initrd seems to make the problem go away..
Any idea why that could happen?
