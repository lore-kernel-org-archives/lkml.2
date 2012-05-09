Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab2EIIUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:20:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37201 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab2EIIT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:19:59 -0400
Subject: Re: [linux-pm] [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <EF62F09C0797D947AD4180A1043C0DF73C40C247@DLEE10.ent.ti.com>
Date: Wed, 9 May 2012 10:19:55 +0200
Cc: "Hilman, Kevin" <khilman@ti.com>, "AnilKumar, Chimata" <anilkumar@ti.com>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7F5F5AD1-DC14-4693-817E-ADCC9EFB3D3D@dominion.thruhere.net>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com> <20120426191159.GA9415@sirena.org.uk> <CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com> <20120427175657.GP18260@opensource.wolfsonmicro.com>	<87397o3n4y.fsf@ti.com> <331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com> <87mx5jy2li.fsf@ti.com> <331ABD5ECB02734CA317220B2BBEABC13E9B6681@DBDE01.ent.ti.com> <EF62F09C0797D947AD4180A1043C0DF73C40BCE1@DLEE10.ent.ti.com> <87lil2jp2z.fsf@ti.com> <EF62F09C0797D947AD4180A1043C0DF73C40C247@DLEE10.ent.ti.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 9 mei 2012, om 02:39 heeft Woodruff, Richard het volgende geschreven:

>> From: Hilman, Kevin
>> Sent: Tuesday, May 08, 2012 5:17 PM
> 
>> A basic OMAP AVS driver has been in mainline for a long time, yet we
>> have not seen support submitted for all of these features.
> 
> 1.5/3.5 is a feature.
> 
> ABB is requirement for a production useable driver. 

ABB/FBB is also needed for 1GHz support on omap3 based SoCs like AM37xx and DM37xx.

regards,

Koen