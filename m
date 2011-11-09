Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KIBWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:22:52 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:5057 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KIBWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:22:50 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 9 Nov 2011 09:22:38 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111109012237.GA2231@nchen-desktop>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 11:27:12AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi Heikki,
> 
> On Fri, Oct 28, 2011 at 6:05 PM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
> > This is the first step in separating USB transceivers from
> > USB OTG utilities.
> >
> > Includes fixes to IMX code from Sascha Hauer.
> 
> I tend to defer with your opinion of renaming otg_transceiver to
> usb_phy. According to me otg_transceiver should program hardware
> mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
> for transmitting data over differential data lines (with its own
> programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> in my opinion otg_transceiver and usb_phy should be two different and
> separate entities.
> 
I am a little puzzled, are there two separate analog usb parts at OMap
's usb part? What the transceiver do? And what the phy do?
> I would have preferred to rename otg_transceiver as usb_otg as the
> first step. (this differs from your implementation where you rename
> otg_transceiver to usb_phy and create a new structure usb_otg to
> separate otg members from usb_phy).
> 
> But it should have been first  rename otg_transceiver as usb_otg. Then
> create a new structure usb_phy to move all the phy specific
> implementation there. This kind of implementation will also help when
> we want to have independent phy drivers.
> 
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen

