Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0IWVQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:16:34 -0400
Received: from peacock.arvixe.com ([174.122.104.66]:43642 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab0IWVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:16:32 -0400
X-Greylist: delayed 3560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 17:16:32 EDT
Subject: Re: [PATCH v4 0/2] Get and Set Feature Reports on HIDRAW (USB and
 Bluetooth)
From: Przemo Firszt <przemo@firszt.eu>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Ville Tervo <ville.tervo@nokia.com>, ext Alan Ott <alan@signal11.us>,
        Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <AANLkTinJXYbZh_MvG81iJMu84LKBOKL3s-Gbfe77Vq7q@mail.gmail.com>
References: <1281442367.12579.206.camel@localhost.localdomain>
	 <1281990059-3562-1-git-send-email-alan@signal11.us>
	 <20100923162521.GA15641@null>
	 <AANLkTinJXYbZh_MvG81iJMu84LKBOKL3s-Gbfe77Vq7q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 21:16:19 +0100
Message-ID: <1285272979.2869.14.camel@pldmachine>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 PLD Linux 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2010-09-23, czw o godzinie 10:07 -0700, Ping Cheng pisze:
> On Thu, Sep 23, 2010 at 9:25 AM, Ville Tervo <ville.tervo@nokia.com> wrote:
> > Hi Alan,
> >
> > On Mon, Aug 16, 2010 at 10:20:57PM +0200, ext Alan Ott wrote:
> >> This is version 4. Built against 2.6.35+ revision 320b2b8de12698 .
> >
> > I gave a try to to this patch using your test tool [1] and very old BT
> > keyboard. I don't have anything else ATM to test with. Is there some BT hid
> > devices which support setting and getting features?
> 
> As far as I know Wacom BT devices (Graphire and Intuos4) need to get
> and set features.
> 
> Przemo,
> 
> Do you have time to test the patchset with your Graphire BT and
> provide your result here?
Hi Ping,
Speed switching works as expected.

Tested on HP NC4200 with internal and external bluetooth modules:

Linux pldmachine 2.6.35-07788-g320b2b8-dirty #15 Thu Sep 23 19:55:03 IST
2010 i686 Intel(R)_Pentium(R)_M_processor_1.86GHz PLD Linux

ID 03f0:011d Hewlett-Packard Integrated Bluetooth Module
ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)

and Wacom Pen Tablet CTE-630BT

Tested-by: Przemo Firszt <przemo@firszt.eu>
-- 
Regards,
Przemo Firszt <przemo@firszt.eu>

