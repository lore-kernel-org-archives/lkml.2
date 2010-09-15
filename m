Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0IOKnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:43:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39324 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0IOKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:43:20 -0400
Message-ID: <4C90A2E3.9020300@mvista.com>
Date: Wed, 15 Sep 2010 14:41:39 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: balbi@ti.com
CC: Ming Lei <tom.leiming@gmail.com>, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <20100914105402.GD7554@legolas.emea.dhcp.ti.com> <4C8FB60D.1080906@ru.mvista.com> <20100915065345.GC3393@legolas.emea.dhcp.ti.com> <4C909961.10001@ru.mvista.com> <20100915100553.GJ3393@legolas.emea.dhcp.ti.com> <4C909B2E.3000909@ru.mvista.com> <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com> <4C909D87.2090901@ru.mvista.com> <20100915102256.GK3393@legolas.emea.dhcp.ti.com> <4C909F99.9050300@mvista.com> <20100915103152.GM3393@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100915103152.GM3393@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-09-2010 14:31, Felipe Balbi wrote:

>> IMHO, this fix as it is now is quite stupid. It's clear that the check is
>> misplaced and will be removed once the ZLP fix is done. So why not do it once

> your forgetting the fact that not always you need to send ZLP after
> completing a packet_size-aligned transfer,

    So what?

> so that check will have to stay where it is.

    I don't see how these two are connected at all.

 >> and for all? Is it so hard to do? FWIW, I NAK this patch as it is now.

 > ok, but I don't.

    Well, you're the maintainer.

WBR, Sergei
