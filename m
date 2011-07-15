Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1GONSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:18:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42108 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750849Ab1GONSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:18:02 -0400
Date: Fri, 15 Jul 2011 22:17:51 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715131748.GD10026@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715123121.735688a6@endymion.delvare>
 <20110715121646.GA10026@opensource.wolfsonmicro.com>
 <20110715145848.750a85aa@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715145848.750a85aa@endymion.delvare>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 02:58:48PM +0200, Jean Delvare wrote:
> On Fri, 15 Jul 2011 21:16:50 +0900, Mark Brown wrote:

> > Does that sound reasonable to you?

> Yes, no objection.

BTW, if this does sound reasonable are you OK with adding your ack for
the I2C bus interface patch or are there any updates you want me to do?
