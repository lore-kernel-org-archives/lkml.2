Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2BEVz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:55:28 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:38674 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751709Ab2BEVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:54:38 -0500
Date: Sun, 5 Feb 2012 22:13:15 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use
 module_platform_driver()
Message-ID: <20120205211315.GB13598@comet.dominikbrodowski.net>
Mail-Followup-To: Axel Lin <axel.lin@gmail.com>,
	linux-kernel@vger.kernel.org,
	Michael Hennerich <hennerich@blackfin.uclinux.org>,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Olof Johansson <olof@lixom.net>, Marc Zyngier <maz@misterjones.org>,
	Ralf Baechle <ralf@linux-mips.org>,
	Eric Miao <eric.y.miao@gmail.com>, linux-pcmcia@lists.infradead.org
References: <1322369586.2522.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322369586.2522.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 12:53:06PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/pcmcia/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Marc Zyngier <maz@misterjones.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

Best,
	Dominik
