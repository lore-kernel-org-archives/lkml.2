Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1IFBr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 21:47:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53658 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753388Ab1IFBrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 21:47:25 -0400
Date: Mon, 5 Sep 2011 18:47:19 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 0/6 v2] Introduce caching support for regmap
Message-ID: <20110906014718.GE31600@opensource.wolfsonmicro.com>
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 02:50:56PM +0100, Dimitris Papastamos wrote:
> This patch series introduces register caching support for regmap.  I've
> implemented all the suggestions since v1, except the use of a dedicated
> init function for each of the compress types.  Due to lack of time, I'll
> submit the updated patches in a couple of days.  I'm aware this can't be
> merged as is due to this outstanding change, but I'm posting it in any case
> for reviewing.

This is looking good - the major thing is the Kconfig stuff to make sure
it's properly enabled.
