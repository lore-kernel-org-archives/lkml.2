Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0IOKXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:23:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35488 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab0IOKXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:23:16 -0400
Date: Wed, 15 Sep 2010 13:22:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ming Lei <tom.leiming@gmail.com>, "Balbi, Felipe" <balbi@ti.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
Message-ID: <20100915102256.GK3393@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4C909D87.2090901@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 15, 2010 at 05:18:47AM -0500, Sergei Shtylyov wrote:
>    I don't see why we should fix only this problem, while it's obvious tha
>the fix is incomplete and leaves the other problem exposed. Please recast the
>patch.

IMO, the ZLP fix is *another* fix and as such subject to a different
patch.

-- 
balbi
