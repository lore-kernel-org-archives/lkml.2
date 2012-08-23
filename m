Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030442Ab2HWOxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:53:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48087 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2HWOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:53:21 -0400
Date: Thu, 23 Aug 2012 15:53:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "rabin.vincent@gmail.com" <rabin.vincent@gmail.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled
 for boot-on
Message-ID: <20120823145308.GA28328@sirena.org.uk>
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
 <5034AA28.5050306@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5034AA28.5050306@nvidia.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:15:12PM +0530, Laxman Dewangan wrote:
> Hi Rabin,
> Is it resolved the issue you mentioned?

He replied to your mail pointing out that it generated a lockdep issue.
