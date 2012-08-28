Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2H1QtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:49:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab2H1QtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:49:24 -0400
Date: Tue, 28 Aug 2012 09:49:22 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: Re: [PATCH 4/6] mfd: palmas add device tree handling to mfd
Message-ID: <20120828164921.GB4534@opensource.wolfsonmicro.com>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
 <1346154460-20031-5-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154460-20031-5-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:47:38PM +0200, Graeme Gregory wrote:
> Add device tree handling to the palmas MFD. This takes the values
> that can be set from platform data from the device tree nodes instead.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/mfd/palmas.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)

Any new device tree bindings should be documented.
