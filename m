Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1CRGas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 02:30:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59459 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1CRGal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 02:30:41 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Date: Fri, 18 Mar 2011 12:00:04 +0530
Subject: RE: [PATCH v8 03/11] gpio: add ti-ssp gpio driver
Thread-Topic: [PATCH v8 03/11] gpio: add ti-ssp gpio driver
Thread-Index: Acvk03lBsqkjwknTRxu6xhjqKmko3wAWObqw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C3B8330@dbde02.ent.ti.com>
References: <1295378505-15221-1-git-send-email-cyril@ti.com>
 <1295378505-15221-4-git-send-email-cyril@ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024BF35DAF@dbde02.ent.ti.com>
 <20110317184514.GP9597@angua.secretlab.ca>
In-Reply-To: <20110317184514.GP9597@angua.secretlab.ca>
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

Hi Grant,

On Fri, Mar 18, 2011 at 00:15:14, Grant Likely wrote:
> On Mon, Feb 28, 2011 at 06:04:32PM +0530, Nori, Sekhar wrote:
> > Hi Grant,
> > 
> > On Wed, Jan 19, 2011 at 00:51:37, Chemparathy, Cyril wrote:
> > > TI's SSP controller pins can be directly read and written to behave like a
> > > GPIO.  This patch adds a GPIO driver that exposes such functionality.
> > 
> > Can you please review and ack the GPIO part of this
> > series too?
> > 
> > I see that you have already acked the SPI part of this work.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Sorry for the delay on this.  I can take it through my tree if you
> like.  It's a new driver, so I don't have any concerns about taking it
> now even though the merge window is already open..

Please queue this for the 2.6.40 cycle. I just noticed that with
the 2.6.39 merge, the mfd portion of this needs a linux/sched.h
include to build successfully. That would be fixed in the 2.6.39-rc cycle.

Thanks,
Sekhar

