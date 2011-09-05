Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1IEPAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:00:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37309 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752546Ab1IEPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:00:43 -0400
Date: Mon, 5 Sep 2011 08:00:40 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: regmap module_put usage.
Message-ID: <20110905150040.GB3889@opensource.wolfsonmicro.com>
References: <4E64C6B3.80105@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64C6B3.80105@cam.ac.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 01:55:15PM +0100, Jonathan Cameron wrote:

> Right now, calling regmap_exit() results in a module_put of the
> regmap-spi module which never has a module_get and hence it's
> module use count wraps around and all hell breaks loose?

Oh, that's a bit of bitrot from a last minute reorg.  I'll fix it.
