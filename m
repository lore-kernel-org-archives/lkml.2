Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1KIA5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:57:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32815 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab1KIA5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:57:13 -0500
Date: Wed, 9 Nov 2011 00:57:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Add helper function for checking if a
 register range is volatile
Message-ID: <20111109005705.GA3147@opensource.wolfsonmicro.com>
References: <1320773846-28635-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320773846-28635-1-git-send-email-lars@metafoo.de>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:37:25PM +0100, Lars-Peter Clausen wrote:
> We already have the same code for checking whether a register range is volatile
> in two different places. Instead of duplicating it once more  add a small helper
> function for checking whether a register range is voltaile.

Applied both, thanks!
