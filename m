Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0IMIza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:55:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40887 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671Ab0IMIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:55:28 -0400
Date: Mon, 13 Sep 2010 09:55:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        elinwal <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100913085526.GE16606@rakim.wolfsonmicro.main>
References: <4C8DE1BE.30304@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8DE1BE.30304@stericsson.com>
X-Cookie: Go 'way!  You're bothering me!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:33:02AM +0200, Mattias Wallin wrote:
> This patch adds the possibility to read and write registers
> via the debug_fs. It also adds ranges of registers sorted by bank
> which makes it possible to read all defined registers in a bank.
> 
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
