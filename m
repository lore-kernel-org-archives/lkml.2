Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1CPLXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:23:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34622 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CPLW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:22:59 -0400
Subject: Re: [PATCH v3] Regulator: add suspend-finish API for regulator
 core.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Igor Grinberg <grinberg@compulab.co.il>
In-Reply-To: <20110314150330.GE2626@opensource.wolfsonmicro.com>
References: <1299806039-12698-1-git-send-email-myungjoo.ham@samsung.com>
	 <20110314150330.GE2626@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 11:22:54 +0000
Message-ID: <1300274574.3432.42.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:03 +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 10:13:59AM +0900, MyungJoo Ham wrote:
> > The regulator core had suspend-prepare that turns off the regulators
> > when entering a system-wide suspend. However, it did not have
> > suspend-finish that pairs with suspend-prepare and the regulator core
> > has assumed that the regulator devices and their drivers support
> > autonomous recover at resume.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam

