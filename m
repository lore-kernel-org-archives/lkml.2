Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0HIJgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:36:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab0HIJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:36:22 -0400
Subject: Re: [PATCH 1/4] mfd: max8998 - fix incorrect kfree(i2c) in
 i2c_driver probe callback handler
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100809091530.GB2513@sortiz-mobl>
References: <1281336496.18804.2.camel@mola>
	 <20100809091530.GB2513@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 10:36:12 +0100
Message-ID: <1281346572.3035.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 11:15 +0200, Samuel Ortiz wrote:
> Hi Axel,
> 
> On Mon, Aug 09, 2010 at 02:48:16PM +0800, Axel Lin wrote:
> > The i2c_client received in probe() should not be kfree()'d.
> This should go through Liam's tree, I'm  CC'ing him to this thread.

Thanks, I assume I have you Ack too ?

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

