Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1ILQiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:38:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44315 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751092Ab1ILQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:38:14 -0400
Date: Mon, 12 Sep 2011 17:38:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm831x-spi: use id_table rather hand rolled variant
 handling
Message-ID: <20110912163812.GE5887@opensource.wolfsonmicro.com>
References: <1315842302-27607-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315842302-27607-1-git-send-email-jacmet@sunsite.dk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 05:45:02PM +0200, Peter Korsgaard wrote:
> The spi subsystem supports device tables nowadays, so use it.
> 
> Only build tested as I don't have the hw.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Non-bugfix patches like this should always be submitted against the
latest code in -next unless the subsystem is being unusual.  I can tell
you're not working against the latest -next becuase it has a version of
this in it already.  :)
