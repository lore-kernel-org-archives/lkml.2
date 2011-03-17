Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1CQHdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:33:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52461 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1CQHdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:33:50 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Chemparathy, Cyril" <cyril@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Hilman, Kevin" <khilman@ti.com>
Date: Thu, 17 Mar 2011 13:03:12 +0530
Subject: RE: [PATCH v8 01/11] mfd: add driver for sequencer serial port
Thread-Topic: [PATCH v8 01/11] mfd: add driver for sequencer serial port
Thread-Index: AcvA329GenpCr9L1TQStBlowmWKwZAjlRp0A
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C307FE5@dbde02.ent.ti.com>
References: <1295378505-15221-1-git-send-email-cyril@ti.com>
	<1295378505-15221-2-git-send-email-cyril@ti.com>	<87tyh4u6uo.fsf@ti.com>
 <20110131004001.GF2565@sortiz-mobl>
In-Reply-To: <20110131004001.GF2565@sortiz-mobl>
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

Hi Cyril,

On Mon, Jan 31, 2011 at 06:10:02, Samuel Ortiz wrote:
> Hi Kevin,
> 
> On Wed, Jan 19, 2011 at 09:43:43AM -0800, Kevin Hilman wrote:
> > Samuel,
> > 
> > Cyril Chemparathy <cyril@ti.com> writes:
> > 
> > > TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
> > > device.  It has a built-in programmable execution engine that can be programmed
> > > to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
> > >
> > > This patch adds a driver for this controller device.  The driver does not
> > > expose a user-land interface.  Protocol drivers built on top of this layer are
> > > expected to remain in-kernel.
> > >
> > > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > 
> > Any comments on this driver?
> The driver looks fine.
> 
> 
> > With your ack, I'll be happy to merge this via the davinci tree with the
> > rest of the series.
> Please go ahead and add my Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Patches in this series which have been Acked by respective maintainers
have been included in the 2.6.39 pull request Kevin sent to Russell.

Once 2.6.39-rc1 is out, can you please plan to rebase and repost the
left out patches and ask the respective maintainers for their review and
ack?

Thanks,
Sekhar
