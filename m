Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1JML2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:28:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50461 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1JML2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:28:16 -0400
thread-index: AcyJmy6X88eCDP7DQaarT6/QfQTUEQ==
Content-Transfer-Encoding: 7bit
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures for omap3
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        "Basak, Partha" <p-basak2@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        <parthab@india.ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Gadiyar, Anand" <gadiyar@ti.com>, <sameo@linux.intel.com>,
        <tony@atomide.com>, "Hilman, Kevin" <khilman@ti.com>,
        <johnstul@us.ibm.com>, "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
In-Reply-To: <CAP05o4K2EzAKDgC9EdfEURCfcM=M7TRJdBuAtRafL2RHg+qTag@mail.gmail.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com> <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com> <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com> <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com> <cbad72cea703d117067f7c628f7db806@mail.gmail.com> <1317127327.3820.31.camel@sokoban> <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com> <CAP05o4K2EzAKDgC9EdfEURCfcM=M7TRJdBuAtRafL2RHg+qTag@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-7UEUCA4W3nVPe2HwxA5J"
Organization: Texas Instruments
Date: Thu, 13 Oct 2011 14:28:03 +0300
Message-ID: <1318505283.23199.4.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-7UEUCA4W3nVPe2HwxA5J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-10-13 at 09:12 +0200, Munegowda, Keshava wrote:
> On Tue, Sep 27, 2011 at 6:48 PM, Munegowda, Keshava
> <keshava_mgowda@ti.com> wrote:
> > On Tue, Sep 27, 2011 at 6:12 PM, Tero Kristo <t-kristo@ti.com> =
wrote:
> >> On Tue, 2011-09-27 at 08:04 +0200, Basak, Partha wrote:
> >>> >
> >> Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: =
0115040-6. Kotipaikka: Helsinki
> >>
> >>=20
Texas Instruments Oy, Porkkalankatu 22, 00180 Helsinki, Finland. =
Business ID: 0115040-6. Domicile: Helsinki
=20
-----Original Message-----

> >>
> >>> >From: Munegowda, Keshava [mailto:keshava_mgowda@ti.com]
> >>> >Sent: Monday, September 26, 2011 7:49 PM
> >>> >To: Paul Walmsley; Tero Kristo; b-cousson@ti.com; balbi@ti.com;
> >>> >parthab@india.ti.com
> >>> >Cc: linux-usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
> >>> >kernel@vger.kernel.org; gadiyar@ti.com; sameo@linux.intel.com;
> >>> >tony@atomide.com; khilman@ti.com; johnstul@us.ibm.com;
> >>> >vishwanath.bs@ti.com
> >>> >Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod
> >>> >structures for omap3
> >>> >
> >>> >On Sat, Sep 24, 2011 at 12:00 PM, Paul Walmsley <paul@pwsan.com> =
wrote:
> >>> >> On Fri, 23 Sep 2011, Munegowda, Keshava wrote:
> >>> >>
> >>> >>> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley =
<paul@pwsan.com>
> >>> >wrote:
> >>> >>>
> >>> >>> But the question arises here , why do we need these ehci and =
ohci as
> >>> >two
> >>> >>> different hwmods containing only irq and base address? It is =
required
> >>> >>> for future - to implement remote wakeup feature for ehci and =
ohci
> >>> >ports
> >>> >>> depending on irq-chain handler patches by Tero. Separate =
hwmods for
> >>> >ehci
> >>> >>> and ohci are needed to enable prcm chain-handler to uniquely =
identify
> >>> >>> the wakeup source as ehci or ohci and call only the =
corresponding
> >>> >>> interrupt handler. We will be using omap_hwmod_mux_init for =
ehci and
> >>> >>> ohci hwmods to enable I/O wakeup capability for respective =
IO-pads.
> >>> >>> Depending on the particular wakeup source(ehci/ohci), the
> >>> >corresponding
> >>> >>> ehci or ohci irq handler will be called.
> >>> >>>
> >>> >>> If ehci and ohci are combined with usbhs hwmod as a single =
hwmod ,
> >>> >then
> >>> >>> for every wakeup (either ehci or ohci port wakeup) only the =
first
> >>> >>> interrupt handler will be called (please look at the function
> >>> >>> omap_hwmod_mux_handle_irq of
> >>> >>>
> >>> >>> /arch/arm/mach-omap2/mux.c file ; in tero's latest patch:
> >>> >>> =
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg53139.html)
> >>> >>> , so in this
> >>> >>> case, if ehci interrupt is the first interrupt , then even for =
ohci
> >>> >wakeup
> >>> >>> , only ehci interrupt will get called; which will break the
> >>> >functionality.
> >>> >>
> >>> >> Any reason why this couldn't be handled either by:
> >>> >>
> >>> >> 1. adding an IRQ number field to struct omap_hwmod_mux_info, =
and
> >>> >changing
> >>> >> _omap_hwmod_mux_handle_irq() to raise that IRQ number?
> >>> >
> >>> >
> >>> >yes, it is possible by changing the existing irq-chain handler by =
tero
> >>> >Kristo
> >>> >
> >>> >I am looping tero too.
> >>> >
> >>> >So here are new requirements for the irq-chain handler
> >>> >
> >>> >1. The hwmod should have have option to have multiple mux =
structures
> >>> >
> >>> >This is something like:
> >>> >
> >>> >The existing mux structure definition in omap_hwmod [file:
> >>> >/arch/arm/plat-omap/include/plat/omap_hwmod.h ] structure
> >>> >
> >>> >     struct omap_hwmod_mux_info      *mux;
> >>> >
> >>> >it should changed to
> >>> >
> >>> >     struct omap_hwmod_mux_info      **pmux;
> >>> >         U32                                            mux_cnt;
> >>> >
> >>> >
> >>> >pmux - pointers to mux ; array of mux structures.
> >>> >mux_cnt - number of mux per hwmod.
> >>> >
> >>> >
> >>> >2. The mux  omap_hwmod_mux_info  structure should have new member
> >>> >called irq, like as follows:
> >>> >
> >>> >struct omap_hwmod_mux_info {
> >>> >     int                             nr_pads;
> >>> >     ...
> >>> >        ....
> >>> >        u32                           irq;
> >>> >
> >>> >};
> >>> >
> >>> >Upon wakeup of the I/O pad of the mux , the irq-chain handler =
should
> >>> >invoke the irq handler of the irq numbered =
<map_hwmod_mux_info.irq>
> >>> >
> >>> >3.  There should be "SOME WAY" to supply the irqs  from hwmod
> >>> >structure (omap_hwmod) to mux structure (omap_hwmod_mux_info)
> >>> >
> >>> >
> >>> >if you , tero and other opensource people are aligned on the =
proposed
> >>> >changes on the irq-handler ;
> >>> >then it is possible to have two hwmods ( usbhs and tll) for =
usbhost
> >>> >driver.
> >>> >please let me know you comments on the above approach.
> >>> >
> >>>
> >>> Hello Tero,
> >>>
> >>> I would like to draw your attention to the following thread:
> >>>
> >>> We need to support the following:
> >>> 1. Ability to associate multiple mux info to a hwmod.
> >>> 2. Able to associate a particular irq handler to a mux info.
> >>> 3. PRCM Chain handler should loop through all mux-info arrays
> >>>    for a particular hwmod to identify the possible wakeup =
source(s)
> >>>    and call the appropriate irq handler for that mux-info.
> >>>    (It is possible that both mux-info are woken up in which case =
both
> >>> handlers should be called).
> >>>
> >>> To give you a little more perspective, EHCI & OHCI are =
co-controllers
> >>> under UHH/TLL.
> >>> They do not get presented separately to the OCP bus, hence do not =
qualify
> >>> as separate hwmods
> >>> (Paul had objected to the design approach representing EHCI & OHCI =
as
> >>> different hwmods).
> >>>
> >>> However, we need a mechanism to efficiently identify/distinguish
> >>> remote-wakeup, connect/disconnect
> >>> On to an EHCI port vs an OHCI port & call only the correct =
interrupt
> >>> handler(EHCI or OHCI).
> >>>
> >>>  To incorporate this, chain handler implementation would need some
> >>> enhancements.
> >>>  We can look into the details in the next merge window cycle in
> >>> conjunction with aggressive clock management support for =
EHCI/OHCI.
> >>>  But fundamentally, if you are aligned to the approach, we can go =
ahead
> >>> collapsing the EHCI & OHCI hwmods into one.
> >>
> >> Hi,
> >>
> >> So, you would need a mechanism to do something like this:
> >>
> >> pad a or b wakeup detected -> irq0
> >> pad c or d wakeup detected -> irq1?
> >
> > yes, if get something like this , its perfect.
>=20
> Hi Tero
>            Are you posting the patches with these changes?
> please let me know when you will be able to post the patches.
> so that I start the design of usb host remote wakeup using your =
changes.
>=20
> regards
> keshava
>=20

Sorry for the delay, but I am still not quite sure how this should be
handled for upstream. Attached is a proposal hack patch that should
work, you can at least try it out to see what happens. It applies on top
of my latest PRCM chain handler set (version 9.) Patch desc contains a
guide how to use it.

-Tero


>=20
>=20
>=20
> >
> >>
> >> Is it okay to do this:
> >>
> >> pad a...d wakeup -> irq0 and irq1?
> >
> > No, we dont need multiple irq handlers for single wakeup source.
> >
> >>
> >> I am okay doing something like this, we just need to agree how this
> >> would be represented from the hwmod point of view. Currently the =
chain
> >> handler set does not change hwmod structures at all to provide what =
it
> >> does.
> >
> > paul and benoit are the people to design the mechanisam for this.
> >
> > paul/Benoit
> >            please give you thoughts on this.
> >
> > regards
> > keshava
> >
> >
> >>
> >> -Tero
> >>
> >>> >
> >>> >>
> >>> >> or
> >>> >>
> >>> >> 2. using shared interrupts?
> >>> >>
> >>> >>
> >>> >> - Paul
> >>> >>
> >>
> >>
> >>
> >


--=-7UEUCA4W3nVPe2HwxA5J
Content-Disposition: attachment;
	filename="0001-HACK-omap-mux-add-support-for-separate-wakeup-irq-fo.patch"
Content-Type: text/x-patch; charset="UTF-8";
	name="0001-HACK-omap-mux-add-support-for-separate-wakeup-irq-fo.patch"
Content-Transfer-Encoding: 7bit

>From fff5f3ef281eafe2229811eaa2661176e9582db2 Mon Sep 17 00:00:00 2001
From: Tero Kristo <t-kristo@ti.com>
Date: Thu, 13 Oct 2011 14:21:09 +0300
Subject: [PATCH] HACK: omap: mux: add support for separate wakeup irq for each pad

By default all registered pads will trigger mpu_irqs[0]. This patch
adds an API that allows separate irqs for each pad.

Usage:

int irqs[nr_pads] = { 1, 2, 3 };
...
mux = omap_hwmod_mux_init(pads, nr_pads);
omap_hwmod_mux_init_irqs(mux, irqs);

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/mux.c                    |   21 +++++++++++++++------
 arch/arm/mach-omap2/mux.h                    |    2 ++
 arch/arm/mach-omap2/omap_hwmod.c             |    7 -------
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    1 +
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 642fe3f..e9ac904 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -354,6 +354,14 @@ err1:
 	return NULL;
 }
 
+int omap_hwmod_mux_init_irqs(struct omap_hwmod_mux_info *mux, int *irqs)
+{
+	if (!mux || !irqs)
+		return -EINVAL;
+	mux->irqs = irqs;
+	return 0;
+}
+
 /**
  * omap_hwmod_mux_get_wake_status - omap hwmod check pad wakeup
  * @hmux:		Pads for a hwmod
@@ -362,11 +370,10 @@ err1:
  * Returns true if wakeup event is set for pad else false
  * if wakeup is not occured or pads are not avialable.
  */
-bool omap_hwmod_mux_get_wake_status(struct omap_hwmod_mux_info *hmux)
+static bool omap_hwmod_mux_scan_wakeups(struct omap_hwmod_mux_info *hmux)
 {
 	int i;
 	unsigned int val;
-	u8 ret = false;
 
 	for (i = 0; i < hmux->nr_pads; i++) {
 		struct omap_device_pad *pad = &hmux->pads[i];
@@ -375,15 +382,17 @@ bool omap_hwmod_mux_get_wake_status(struct omap_hwmod_mux_info *hmux)
 			val = omap_mux_read(pad->partition,
 					pad->mux->reg_offset);
 			if (val & OMAP_WAKEUP_EVENT) {
-				ret = true;
 				pr_info("wkup detected: %04x\n",
 					pad->mux->reg_offset);
-				break;
+				if (hmux->irqs)
+					generic_handle_irq(hmux->irqs[i]);
+				else
+					return true;
 			}
 		}
 	}
 
-	return ret;
+	return false;
 }
 
 /**
@@ -396,7 +405,7 @@ static int _omap_hwmod_mux_handle_irq(struct omap_hwmod *oh, void *data)
 {
 	if (!oh->mux || !oh->mux->enabled)
 		return 0;
-	if (omap_hwmod_mux_get_wake_status(oh->mux))
+	if (omap_hwmod_mux_scan_wakeups(oh->mux))
 		generic_handle_irq(oh->mpu_irqs[0].irq);
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/mux.h b/arch/arm/mach-omap2/mux.h
index 8b2150a..24e1981 100644
--- a/arch/arm/mach-omap2/mux.h
+++ b/arch/arm/mach-omap2/mux.h
@@ -216,6 +216,8 @@ int omap_mux_init_signal(const char *muxname, int val);
 extern struct omap_hwmod_mux_info *
 omap_hwmod_mux_init(struct omap_device_pad *bpads, int nr_pads);
 
+extern int omap_hwmod_mux_init_irqs(struct omap_hwmod_mux_info *mux, int *irqs);
+
 /**
  * omap_hwmod_mux - omap hwmod specific pin muxing
  * @hmux:		Pads for a hwmod
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index a8b24d7..e751dd9 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2724,10 +2724,3 @@ int omap_hwmod_no_setup_reset(struct omap_hwmod *oh)
 
 	return 0;
 }
-
-int omap_hwmod_pad_get_wakeup_status(struct omap_hwmod *oh)
-{
-	if (oh && oh->mux)
-		return omap_hwmod_mux_get_wake_status(oh->mux);
-	return -EINVAL;
-}
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index 9c70cc8..2a9ce37 100644
--- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
+++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
@@ -97,6 +97,7 @@ struct omap_hwmod_mux_info {
 	struct omap_device_pad		*pads;
 	int				nr_pads_dynamic;
 	struct omap_device_pad		**pads_dynamic;
+	int				*irqs;
 	bool				enabled;
 };
 
-- 
1.7.4.1


--=-7UEUCA4W3nVPe2HwxA5J--
