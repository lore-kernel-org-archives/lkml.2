Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660Ab2FVSz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:55:59 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:32774 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab2FVSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:55:58 -0400
Message-ID: <1340391353.12316.0.camel@odin>
Subject: Re: [PATCH] regulator: core: Allow multiple requests of a single
 supply mapping
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 22 Jun 2012 19:55:53 +0100
In-Reply-To: <1340361584-12314-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340361584-12314-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 11:39 +0100, Mark Brown wrote:
> Sometimes it may be useful to allow a device to request a supply multiple
> times, for example in order to allow framework management of some uses of
> the supply with some additional driver specific management or in order to
> allow multiple children of an MFD to work with the supply. Currently this
> is not possible due to the creation of
> 
> Solve this by removing the requested_uA entry (we have no current users
> of this feature anyway) and ignoring errors creating the symlink to the
> consumer. We should do something nicer than this as this causes sysfs to
> spew enormous warnings but it allows users to run for now.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>

