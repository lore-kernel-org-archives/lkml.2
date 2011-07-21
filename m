Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1GUPry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:47:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47426 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752348Ab1GUPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:47:51 -0400
Date: Thu, 21 Jul 2011 16:47:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: ashishj3 <ashish.jangam@kpitcummins.com>, arnd@arndb.de,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110721154748.GB23192@opensource.wolfsonmicro.com>
References: <1309876620.960.169.camel@L-0532.kpit.com>
 <20110721154631.GA26837@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110721154631.GA26837@S2100-06.ap.freescale.net>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 11:46:32PM +0800, Shawn Guo wrote:
> On Tue, Jul 05, 2011 at 08:07:00PM +0530, ashishj3 wrote:

> > +	mutex_lock_interruptible(&da9052->io_lock);

> Compile warning as below.

> "warning: ignoring return value of ‘mutex_lock_interruptible’,
> declared with attribute warn_unused_result"

Although the bigger problem is why are these interruptible?  That's
very unusual.
