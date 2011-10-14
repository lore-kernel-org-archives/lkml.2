Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1JNJwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:52:06 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59246 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab1JNJwE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:52:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110140205460.16865@utopia.booyaka.com>
References: <1318319355-20168-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110131227270.24155@utopia.booyaka.com>
	<alpine.DEB.2.00.1110131857350.24155@utopia.booyaka.com>
	<CAP05o4JAuCtj_i=Nye2afV8vv23i=qC0zO4a7sYP+hcn3QqHnA@mail.gmail.com>
	<alpine.DEB.2.00.1110140205460.16865@utopia.booyaka.com>
Date: Fri, 14 Oct 2011 15:22:02 +0530
Message-ID: <CAP05o4J60+xD_vtfqyqUM3CJPK8LOzWPMUJcJj08RnVnejXD8w@mail.gmail.com>
Subject: Re: [PATCH 2/5 v14] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 1:41 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> On Fri, 14 Oct 2011, Munegowda, Keshava wrote:
>
>> On Fri, Oct 14, 2011 at 6:33 AM, Paul Walmsley <paul@pwsan.com> wrote:
>
>> >  static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>> >        &omap3xxx_l3_main_hwmod,
>> >        &omap3xxx_l4_core_hwmod,
>> > @@ -3151,6 +3365,7 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>> >        &omap3xxx_uart1_hwmod,
>> >        &omap3xxx_uart2_hwmod,
>> >        &omap3xxx_uart3_hwmod,
>> > +
>>
>> why you have removed  &omap3xxx_usb_host_hs_hwmod,
>> and       &omap3xxx_usb_tll_hs_hwmod.?
>
> I have removed them because, according to the OMAP3430 ES1.0 Revision A
> TRM (SWPU100A), the HS USBHOST subsystem is not present on OMAP3430 ES1.0.
> Therefore the HS USBHOST modules must not be marked as being common to all
> OMAP3xxx chips in the hwmod data.
>
> If you have information that indicates that it's present on OMAP3430
> ES1.0, please let me know ASAP.


Thanks , I got your point

regards
keshava





>>
>>
>> >        /* dss class */
>> >        &omap3xxx_dss_dispc_hwmod,
>> >        &omap3xxx_dss_dsi1_hwmod,
>> > @@ -3206,6 +3421,8 @@ static __initdata struct omap_hwmod *omap3430es1_hwmods[] = {
>> >  static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
>> >        &omap3xxx_dss_core_hwmod,
>> >        &omap3xxx_usbhsotg_hwmod,
>> > +       &omap3xxx_usb_host_hs_hwmod,
>> > +       &omap3xxx_usb_tll_hs_hwmod,
>> >        NULL
>> >  };
>> >
>> > @@ -3223,12 +3440,16 @@ static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
>> >        &omap36xx_sr1_hwmod,
>> >        &omap36xx_sr2_hwmod,
>> >        &omap3xxx_usbhsotg_hwmod,
>> > +       &omap3xxx_usb_host_hs_hwmod,
>> > +       &omap3xxx_usb_tll_hs_hwmod,
>> >        NULL
>> >  };
>> >
>> >  static __initdata struct omap_hwmod *am35xx_hwmods[] = {
>> >        &omap3xxx_dss_core_hwmod, /* XXX ??? */
>> >        &am35xx_usbhsotg_hwmod,
>> > +       &omap3xxx_usb_host_hs_hwmod,
>> > +       &omap3xxx_usb_tll_hs_hwmod,
>> >        NULL
>> >  };
>> >
>> > --
>> > 1.7.7
>> >
>> >
>>
>
>
> - Paul
