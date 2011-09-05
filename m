Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1IETzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:55:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57210 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753087Ab1IETzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:55:46 -0400
Date: Mon, 5 Sep 2011 12:55:37 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix regmap compilation with CONFIG_DEBUGFS=n
Message-ID: <20110905195536.GB11107@opensource.wolfsonmicro.com>
References: <1315250978-4242-1-git-send-email-lars@metafoo.de>
 <20110905194254.GA11107@opensource.wolfsonmicro.com>
 <4E6528CD.7080003@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6528CD.7080003@metafoo.de>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 09:53:49PM +0200, Lars-Peter Clausen wrote:
> On 09/05/2011 09:42 PM, Mark Brown wrote:

> > I sense that this doesn't actually happen in mainline...

> Uhm, yes... the patch is still valid though, want me to resubmit it with a
> different patch description?

Yes please, no problem with the patch itself but the description was
obviously bogus (it's fixing a future problem, not a current one).
