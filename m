Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1LHReR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:34:17 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4884 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1LHReQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:34:16 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EE0F50B.5040407@broadcom.com>
Date: Thu, 8 Dec 2011 18:34:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111201@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        b43-dev@lists.infradead.org, "Greg KH" <gregkh@suse.de>
Subject: Re: BCM43224 hanging [3.2.0-rc4-00248-gb835c0f]
References: <20111201224851.GB20536@ethz.ch>
 <4ED8B610.2010703@broadcom.com> <20111202150128.GC3096@schottelius.org>
 <20111207190821.GA1775@schottelius.org>
In-Reply-To: <20111207190821.GA1775@schottelius.org>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62FE29693GG7989862-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 08:08 PM, Nico Schottelius wrote:
> Update:
> 
> The hang situation always happens, when the nic does *not* have
> a connection. And it still covers all network processes (i.e.
> including sudo, wpa_supplicant, postfix, etc.).
> 
> Starting up the computer, having wpa_supplicant connect successfully,
> everything works fine.
> 
> Until the connection is lost or I issue "select_network 4", which
> changes to another network.
> 
> The problem also exists, if I startup wpa_supplicant and there
> is no network connection available.
> 
> Verified that this bug exists in my pathced 3.1.0-rc6-g443452b
> as well as in 3.2.0-rc4-00248-gb835c0f.
> 
> This is rather nasty, because it forces me to reboot as soon as
> I've started up wlan by accident.
> 
> Is there a workaround available somewhere (besides using USB-LAN)?
> 
> Attached are output of 3.1.0-rc6-g443452b, which is the same for
> all failing versions.
> 
> Cheers,
> 
> Nico

Could you try and see what happens when you kill wpa_supplicant.

Gr. AvS

