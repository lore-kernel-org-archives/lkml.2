Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0GANHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:07:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41558 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0GANHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:07:36 -0400
Date: Thu, 1 Jul 2010 14:07:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <linux@arm.linux.org.uk>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
Message-ID: <20100701130724.GC17698@sirena.org.uk>
References: <cover.1277911345.git.siccegge@cs.fau.de> <e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de> <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
X-Cookie: Uncompensated overtime?  Just Say No.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:55:47PM +0900, Jassi Brar wrote:
> On Thu, Jul 1, 2010 at 1:03 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> > SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
> > all references for it from the source code.

> I'd rather have the code compiled unconditionally.

Hrm, if this is part of the default hardware build we should get the
driver merged.
