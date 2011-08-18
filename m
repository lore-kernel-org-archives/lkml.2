Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1HRHy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:54:26 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:47718 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1HRHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:54:22 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 03:54:21 EDT
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
From: Tom _Lin <tom_lin@emc.com.tw>
To: jj_ding@emc.com.tw
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, gaowanlong@cn.fujitsu.com
In-Reply-To: <4E4CABE5.7020900@cn.fujitsu.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
	 <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw>
	 <4E4C80A0.8090708@cn.fujitsu.com> <87d3g347ey.fsf@emc.com.tw>
	 <4E4CA3A9.2010900@cn.fujitsu.com>
	 <CAGS+omB0Ys-vEVq64W85Jmsz=TkgvNqn_iJkxynZJr8wvqifGQ@mail.gmail.com>
	 <4E4CA6B4.5060807@cn.fujitsu.com>
	 <CAGS+omDT1WNBoC-T4zmKx1SnVofLwUdt-pfQDWGicO87xUBqxw@mail.gmail.com>
	 <4E4CABE5.7020900@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 15:49:01 +0800
Message-ID: <1313653741.3495.13.camel@ubuntu1010-Veriton-M275>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ
On Thu, 2011-08-18 at 14:06 +0800, Wanlong Gao wrote:
> On 08/18/2011 02:01 PM, Daniel Kurtz wrote:
> > On Thu, Aug 18, 2011 at 1:44 PM, Wanlong Gao<gaowanlong@cn.fujitsu.com>  wrote:
> >> On 08/18/2011 01:34 PM, Daniel Kurtz wrote:
> >>>
> >>> On Thu, Aug 18, 2011 at 1:31 PM, Wanlong Gao<gaowanlong@cn.fujitsu.com>
> >>>   wrote:
> >>>>
> >>>> On 08/18/2011 01:26 PM, JJ Ding wrote:
> >>>>>
> >>>>> Hi Wanlong Gao,
> >>>>>
> >>>>> On Thu, 18 Aug 2011 11:01:52 +0800, Wanlong
> >>>>> Gao<gaowanlong@cn.fujitsu.com>
> >>>>>   wrote:
> >>>>>>
> >>>>>> On 08/18/2011 09:57 AM, JJ Ding wrote:
> >>>>>>>
> >>>>>>> v3 hardware's packet format is almost identical to v2 (one/three
> >>>>>>> finger
> >>>>>>> touch),
> >>>>>>> except when sensing two finger touch, the hardware sends 12 bytes of
> >>>>>>> data.
> >>>>>>>
> >>>>>>> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
> >>>>>>> ---
> >>>>>>>    Documentation/input/elantech.txt |  104 ++++++++++++++++--
> >>>>>>>    drivers/input/mouse/elantech.c   |  218
> >>>>>>> ++++++++++++++++++++++++++++++++++---
> >>>>>>>    drivers/input/mouse/elantech.h   |   11 ++
> >>>>>>>    3 files changed, 303 insertions(+), 30 deletions(-)
> >>>>>>>
> >>>>>>> +static int determine_packet_v3(struct psmouse *psmouse)
> >>>>>>
> >>>>>> elantech_check_parity_v1
> >>>>>> packet_simple_check_v2
> >>>>>> determine_packet_v3
> >>>>>>
> >>>>>> Why not consistent them?
> >>>>>
> >>>>> OK, how do these names sound to you?
> >>>>>
> >>>>> elantech_check_parity_v1
> >>>>> elantech_packet_check_v2
> >>>>> elantech_packet_check_v3
> >>>>>
> >>>>> Thanks,
> >>>>> jj
> >>>>
> >>>> Yeah, sounds perfectly.
> >>>
> >>> Or just:
> >>>
> >>> elantech_packet_check_v1
> >>> elantech_packet_check_v2
> >>> elantech_packet_check_v3
I prefer this way. 
> >>>
> >>> :)
> >>
> >> Hmm... maybe they can go into an elantech_packet_check()?
> >> like:
> >> case 1:
> >>         ...
> >> case 2:
> >>         ...
> >> What do you think? ;)
> >>
> >> Thanks
> >> -Wanlong Gao
> >
> > Since we've already parsed the hardware type at this point, it seems
> > inefficient to parse it again inside another function.
> > I would prefer individual functions.
> >
> > Thanks,
> > -Daniel
> >
> 
> Yeah, It makes sense.
> 
> Thanks
> -Wanlong Gao
> 

Thanks
-TomLin

