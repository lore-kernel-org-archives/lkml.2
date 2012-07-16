Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2GPNgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:36:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36780 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2GPNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:36:41 -0400
Date: Mon, 16 Jul 2012 14:36:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MAX77693: Fix bug of interrupt handlding for
 MAX77693 devices
Message-ID: <20120716133636.GA22600@sirena.org.uk>
References: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: Orders subject to approval.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 06:41:05PM +0900, Chanwoo Choi wrote:
> This patch fix bug related to interrupt handling for MAX77693 devices.
> - Unmask interrupt masking bit for charger/flash/muic to revolve
> that interrupt isn't happened when external connector is attached.

Shouldn't this be happening when the IRQ is requested?
