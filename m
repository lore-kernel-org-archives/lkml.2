Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0CQXHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:07:03 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:56833 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0CQXHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:07:01 -0400
Subject: Re: [PATCHv2] regulator: Get rid of lockdep warning
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net
In-Reply-To: <c9b72e72ecf154ff6bf96bd956bef7d4c5aca2d4.1268417170.git.ameya.palande@nokia.com>
References: <20100312172156.GB22822@rakim.wolfsonmicro.main>
	 <c9b72e72ecf154ff6bf96bd956bef7d4c5aca2d4.1268417170.git.ameya.palande@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 23:06:59 +0000
Message-ID: <1268867219.3834.23.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 20:09 +0200, Ameya Palande wrote:
> From: Ameya Palande <ameya.palande@nokia.com>
> 
> WARNING: at kernel/lockdep.c:2706 sysfs_add_file_mode+0x4c/0xa8()
> 
> Difference between v1 and v2:
> Moved sysfs_attr_init() call as first one to access the structure.
> 
> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
> CC: Liam Girdwood <lrg@slimlogic.co.uk>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> CC: David Brownell <dbrownell@users.sourceforge.net>
> ---

Applied.

Thanks.

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

