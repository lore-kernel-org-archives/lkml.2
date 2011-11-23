Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1KWFcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:32:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48396 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1KWFb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:31:58 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Girdwood, Liam" <lrg@ti.com>, "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH RESEND v2 2/2] regulator: TPS65910: VDD1/2 voltage
 selector count
Thread-Topic: [PATCH RESEND v2 2/2] regulator: TPS65910: VDD1/2 voltage
 selector count
Thread-Index: AQHMnhm0IA4eqXuk9UmGiMcLlLsh4pWixZmAgBc7OfA=
Date: Wed, 23 Nov 2011 05:31:43 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9023DC4@DBDE01.ent.ti.com>
References: <1320758650-29180-1-git-send-email-afzal@ti.com>
 <20111108155639.GE5632@opensource.wolfsonmicro.com>
In-Reply-To: <20111108155639.GE5632@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Tue, Nov 08, 2011 at 21:26:39, Mark Brown wrote:
> On Tue, Nov 08, 2011 at 06:54:10PM +0530, Afzal Mohammed wrote:
> > Count of selector voltage is required for regulator_set_voltage
> > to work via set_voltage_sel. VDD1/2 currently have it as zero,
> > so regulator_set_voltage won't work for VDD1/2.
> > Update count (n_voltages) for VDD1/2.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 

Can you please help this patch to get into mainline Kernel.
Without this VDD1 & 2 voltages cannot be varied on TPS65910.

This patch applies cleanly to current mainline and is not
dependent on any other patch.

Regards
Afzal
