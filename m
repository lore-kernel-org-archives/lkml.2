Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1DPOAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:00:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38661 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DPOAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nVOn0gfyUVMX1bzARdFKapLB/xEYE/Z9krqxAHF0ZkaRcf+nVmvhG+R9VJrSZpNm6g
         OSPnQMcyv0kfI6D8Dg3mktXKsQJsIEXe72AXR6WKM9Kjm8xOj8E8k71vDRiOPXXm9La1
         2z6zY9hThGjtrGnOD7N8Otjmbfuf6v1zkr5Uw=
MIME-Version: 1.0
In-Reply-To: <20110415195642.22440.qmail@stuge.se>
References: <1302781431.21145.6.camel@dev.znau.edu.ua>
	<BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	<4DA6E9BD.3090404@hauke-m.de>
	<BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
	<1302786900.21965.52.camel@dev.znau.edu.ua>
	<BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
	<1302892585.30441.12.camel@dev.znau.edu.ua>
	<BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
	<1302896541.30441.33.camel@dev.znau.edu.ua>
	<BANLkTinPVaYC14Y=m5iu7GYodkRb6uTuPw@mail.gmail.com>
	<20110415195642.22440.qmail@stuge.se>
Date: Sat, 16 Apr 2011 16:00:39 +0200
Message-ID: <BANLkTinNoX6GBG=6xVC8ZfOO4OyZ_o=sFg@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Arend van Spriel <arend@broadcom.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-arm-kernel@lists.infradead.org, b43-dev@lists.infradead.org
Cc: Peter Stuge <peter@stuge.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/15 Peter Stuge <peter@stuge.se>:
> Rafał Miłecki wrote:
>> > On other hand just broadcom-specific bus looks like good alternative
>> > too but here I just fail to decide on relevant naming.
>>
>> Just bcmamba / bcmaxi?
>
> Do bcm make any other (different) busses that would warrant a more
> specific name, hinting somehow at the wireless cards specifically?
>
> Or is it just cool to have a short name? Me I always like short names.

I don't think Broadcom is going to publish new cards based on AMBA
with totally different cores discovery, agent (wrapper) programming,
etc. However of course we never know that and I think Broadcom does
not as well.

Of the other point there is no sense in calling it
bcm_amba_axi_for_wifi as I believe we can meet other devices than just
wifi on this architecture. So let's just call it bcmamba and there is
not other much better solution. If in the future we will hit some
problems we can always try some renaming, aliasing... we will see.

-- 
Rafał
