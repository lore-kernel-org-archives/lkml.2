Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1JXNRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:17:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53274 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab1JXNRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:17:53 -0400
Date: Mon, 24 Oct 2011 14:17:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Provide a definition of struct gpio for the
 stub gpiolib
Message-ID: <20111024131751.GA24174@sirena.org.uk>
References: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111024120120.GO8708@ponder.secretlab.ca>
 <20111024120706.GD6148@opensource.wolfsonmicro.com>
 <20111024125449.GT8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024125449.GT8708@ponder.secretlab.ca>
X-Cookie: For recreational use only.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:54:49PM +0200, Grant Likely wrote:

> You'll still need a 'struct gpio;' forward decl in asm-generic/gpio.h,
> but that's better than having two copies.  If you craft the patch,
> I'll make sure some build coverage testing is performed before merging
> it.

Actually I don't think we don't need the forward declaration as we can
just declare the struct prior to including the asm header.  Patch to
follow...
