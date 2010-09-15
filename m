Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0IOKh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:37:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53718 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0IOKh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lljue7tk8PzxhbPYXL7anmWW28Y9VhU/gR0Ks41m4VaCKBaqWwgoo++pJ26VgQPWQK
         K47hbaiK1HfhX6748Yj01pJhdbsttFLF7rJQeJlFBjCKO0CuutoAakkf4lEyGHhRdBBM
         OL7UI1KNLx1FEWlosPIfhbYXchurzpz3axvSo=
MIME-Version: 1.0
In-Reply-To: <4C909F99.9050300@mvista.com>
References: <20100914065604.GD2601@legolas.emea.dhcp.ti.com>
	<4C8F527E.40408@ru.mvista.com>
	<20100914105402.GD7554@legolas.emea.dhcp.ti.com>
	<4C8FB60D.1080906@ru.mvista.com>
	<20100915065345.GC3393@legolas.emea.dhcp.ti.com>
	<4C909961.10001@ru.mvista.com>
	<20100915100553.GJ3393@legolas.emea.dhcp.ti.com>
	<4C909B2E.3000909@ru.mvista.com>
	<AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com>
	<4C909D87.2090901@ru.mvista.com>
	<20100915102256.GK3393@legolas.emea.dhcp.ti.com>
	<4C909F99.9050300@mvista.com>
Date: Wed, 15 Sep 2010 18:37:24 +0800
Message-ID: <AANLkTikfEhjLANZ7PkE9pOgu7OMS6Rm+4HEQ+eOxrAhc@mail.gmail.com>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
From: Ming Lei <tom.leiming@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: balbi@ti.com, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/15 Sergei Shtylyov <sshtylyov@mvista.com>:
> On 15.09.2010 14:22, Felipe Balbi wrote:
>
>>> I don't see why we should fix only this problem, while it's obvious tha
>>> the fix is incomplete and leaves the other problem exposed. Please recast
>>> the
>>> patch.
>
>> IMO, the ZLP fix is *another* fix and as such subject to a different
>> patch.
>
>   IMHO, this fix as it is now is quite stupid. It's clear that the check is
> misplaced and will be removed once the ZLP fix is done. So why not do it
> once and for all? Is it so hard to do? FWIW, I NAK this patch as it is now.

Maybe we should open a new thread to discuss the ZLP fix, I'll do it later.

-- 
Lei Ming
