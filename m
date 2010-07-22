Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0GVKzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:55:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50318 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0GVKze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:55:34 -0400
Date: Thu, 22 Jul 2010 11:55:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: m.nazarewicz@samsung.com, m.szyprowski@samsung.com, corbet@lwn.net,
        linux-mm@kvack.org, p.osciak@samsung.com, xiaolin.zhang@intel.com,
        hvaibhav@ti.com, robert.fekete@stericsson.com,
        marcus.xm.lorentzon@stericsson.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100722105518.GJ10930@sirena.org.uk>
References: <000001cb296f$6eba8fa0$4c2faee0$%szyprowski@samsung.com> <20100722183432U.fujita.tomonori@lab.ntt.co.jp> <op.vf8oa80k7p4s8u@pikus> <20100722191658V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722191658V.fujita.tomonori@lab.ntt.co.jp>
X-Cookie: He who laughs last didn't get the joke.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 07:17:42PM +0900, FUJITA Tomonori wrote:

> And adjusting drivers in embedded systems is necessary anyway.

Actually for embedded systems we make strong efforts to ensure that
drivers do not need tuning per system and that where this is unavoidable
we separate the configuration from the driver itself (using either a
driver specific interface or a subsystem one depending on the
genericness) so that the driver does not need modifying.
