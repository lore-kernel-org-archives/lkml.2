Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0CXRr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:47:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40376 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab0CXRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:47:26 -0400
Date: Wed, 24 Mar 2010 17:47:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Samsung SoCs: OneNAND support
Message-ID: <20100324174713.GC26910@sirena.org.uk>
References: <20100324080454.GA24277@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324080454.GA24277@july>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 05:04:54PM +0900, Kyungmin Park wrote:
> Samsung SoCs, s5pc6442, s5pc100, and s5pc110 has own OneNAND controller

> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

It's probably worth pointing out that this depends on the previously
posted addition of cpu_is_() for the Samsung CPUs which Ben hasn't
applied - the merge at least will need to be coordinated with that.
