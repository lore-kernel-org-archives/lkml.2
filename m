Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab2JCP1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:27:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab2JCP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <2608261.j829MQZAuC@flexo>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
 <1349276601-8371-26-git-send-email-florian@openwrt.org> <CAOLZvyHyQGZ=Rs1=k07Saq16aZcntUe8N0Fc5iMoeOTeMpjcSw@mail.gmail.com>
 <2608261.j829MQZAuC@flexo>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Wed, 3 Oct 2012 17:26:52 +0200
Message-ID: <CAOLZvyGSbqN-wMDYJcoB_6GPXvZo3wKPMn1oCWxyFETOerMLSA@mail.gmail.com>
Subject: Re: [PATCH 24/25] MIPS: Alchemy: use the OHCI platform driver
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 5:24 PM, Florian Fainelli <florian@openwrt.org> wrote:
> On Wednesday 03 October 2012 17:21:37 Manuel Lauss wrote:
>> On Wed, Oct 3, 2012 at 5:03 PM, Florian Fainelli <florian@openwrt.org> wrote:
>> > This also greatly simplifies the power_{on,off} callbacks and make them
>> > work on platform device id instead of checking the OHCI controller base
>> > address like what was done in ohci-au1xxx.c.
>>
>> That was by design -- the base address is far more reliable in identifying
> the
>> correct controller instance than the platform device id.   There are systems
>> in the field which don't use the alchemy/common/platform.c file at all.
>
> Fair enough, but the way it was done previously was very error-prone if the
> base address changed for any reason in the platform code, and you did not
> notice it had to be changed in the OHCI driver too, then it simply did not

Since the Alchemy line is dead this point is moot.


> work. By systems in the field you mean out of tree users? If so, I'd say that
> it's up to you to get them maintained or merged.

I'm not against the patch at all, quite the contrary.

Manuel
