Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1IZOp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:45:57 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37782 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1IZOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:45:55 -0400
Date: Mon, 26 Sep 2011 08:45:54 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4+uwuFL8XNFG-wmUW8voYQ4kywyU9Qn-Mng7kv=TzZm9w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109260844360.13188@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com> <alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com> <CAP05o4+uwuFL8XNFG-wmUW8voYQ4kywyU9Qn-Mng7kv=TzZm9w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-873770747-1317048354=:13188"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-873770747-1317048354=:13188
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 26 Sep 2011, Munegowda, Keshava wrote:

> On Sat, Sep 24, 2011 at 12:45 PM, Paul Walmsley <paul@pwsan.com> wrote:
> > On Fri, 23 Sep 2011, Munegowda, Keshava wrote:
> >
> >> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com> wrote=
:
> >> >
> >> > On Thu, 22 Sep 2011, Keshava Munegowda wrote:
> >> >> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.
> >> >>
> >> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> >> >> Reviewed-by: Partha Basak <parthab@india.ti.com>
> >> >> ---
> >> >> =A0arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | =A0271 ++++++++++++=
++++++++++++++++
> >> >> =A01 files changed, 271 insertions(+), 0 deletions(-)
> >> >>
> >> >> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/=
mach-omap2/omap_hwmod_3xxx_data.c
> >> >> index 59fdb9f..d79f728 100644
> >> >> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> >> >> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> >
> >> >> +static struct omap_hwmod_ocp_if omap34xx_f128m_cfg__usb_host_hs =
=3D {
> >> >> + =A0 =A0 .clk =A0 =A0 =A0 =A0 =A0 =A0=3D "usbhost_120m_fck",
> >> >
> >> > This doesn't look right. =A0This is an interface structure record, s=
o it
> >> > should be associated with an interface clock. =A0Is the hardware rea=
lly
> >> > using the functional clock as the interface clock? =A0Or, as seems m=
ore
> >> > likely...
> >>
> >>
> >> Agreed, how about:
> >>
> >> main clock: usbhost_120m_fck
> >> optional f clock: usbhost_48m_fck
> >
> > Assuming the interface clock is enabled, which one of these clocks is
> > needed for UHH register accesses to complete successfully?
>=20
> it is usbhost_48m_fck ;
> so,
> main clock: usbhost_48m_fck
> optional clock : usbhost_120m_fck
>=20
> do you agree?

Yes.


- Paul
--155748971-873770747-1317048354=:13188--
