Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1I2JsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:48:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54364 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab1I2JsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:48:10 -0400
Date: Thu, 29 Sep 2011 10:48:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Timur Tabi <timur@freescale.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/6] ASoC: Remove unused "control_data" field of struct
 cs4270_private
Message-ID: <20110929094805.GC3697@opensource.wolfsonmicro.com>
References: <1317175218.14102.1.camel@phoenix>
 <1317175838.14102.4.camel@phoenix>
 <4E8375ED.1060209@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8375ED.1060209@freescale.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 02:30:53PM -0500, Timur Tabi wrote:

> Although Mark, it would have been nice if you had given me a chance to test this
> change before applying the patch.

With this sort of repetitive change by Axel I'm often not really going
to register which particular dirver he's fixing in a given patch - he's
generally very good and one of the advantages of keeping all the drivers
consistent is that it's easy to deploy subsystem wide changes.
