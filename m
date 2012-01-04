Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab2ADFNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:13:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2ADFNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:13:51 -0500
Date: Wed, 4 Jan 2012 09:13:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>,
        "Barnes, Clifton A." <cabarnes@indesign-llc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nithish Mahalingam <nithish.mahalingam@intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Balaji Rao <balajirrao@openmoko.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] power_supply: convert drivers/power/* to use
 module_platform_driver()
Message-ID: <20120104051346.GB8081@oksana.dev.rtsoft.ru>
References: <1322280070.6458.1.camel@phoenix>
 <A8DC7EA93EFCBD4498E3857AFE65E5F1A5AAB71D@IND07.indesign.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A8DC7EA93EFCBD4498E3857AFE65E5F1A5AAB71D@IND07.indesign.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 02:25:47PM +0000, Barnes, Clifton A. wrote:
> On Fri, Nov 25, 2011, Axel Lin wrote:
> > This patch converts the drivers in drivers/power/* to use the
> > module_platform_driver() macro which makes the code smaller and a bit 
> > simpler.
> 
> Acked-by: Clifton Barnes <cabarnes@indesign-llc.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
