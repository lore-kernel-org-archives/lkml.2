Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1CVJoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:44:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42533 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1CVJoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:44:06 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Mar 2011 15:13:46 +0530
Subject: RE: [PATCH v3 1/7] mfd: add pruss mfd driver.
Thread-Topic: [PATCH v3 1/7] mfd: add pruss mfd driver.
Thread-Index: AcvlaYI3wUiX7dfGRFiMdHbMtqNo/ADBPeBAAAGmbTA=
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47D604@dbde02.ent.ti.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
	<1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024C3B85A5@dbde02.ent.ti.com>
	<20110318123917.GC27129@sirena.org.uk>
 <B85A65D85D7EB246BE421B3FB0FBB593024C47D5EE@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C47D5EE@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 15:05:07, Nori, Sekhar wrote:
> Hi Mark,
> 
> On Fri, Mar 18, 2011 at 18:09:17, Mark Brown wrote:
> > On Fri, Mar 18, 2011 at 05:29:39PM +0530, Nori, Sekhar wrote:
> > 
> > > PRUSS as an IP is not really tied to the DA8xx SoC architecture.
> > > So, can you please name the files ti-pruss* or even just pruss if
> > > MFD folks are okay with it?
> > 
> > This...
> > 
> > > > +EXPORT_SYMBOL(pruss_get_clk_freq);
> > 
> > > This looks strange. Why do we need this? There
> > > is clk_get_rate() API in the kernel would would
> > > seem more suitable.
> > 
> > ...unfortunately conflicts with this - currently all clock API
> > implementations are unique to the platform and there's no way of adding
> > clocks that works over multiple platforms.
> 
> Hmm, I guess I have a limited view of this. We do have drivers which
> use clock API and work across OMAP and DaVinci series of ARM SoCs.
> The clock implementation in this case is under mach-omap and mach-davinci

This should have read "under plat-omap/mach-omap2 and mach-davinci"

Thanks,
Sekhar

