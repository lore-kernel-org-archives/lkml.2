Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2GaNfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:35:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33337 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab2GaNfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:35:30 -0400
Date: Tue, 31 Jul 2012 14:35:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] GPIO changes for v3.6
Message-ID: <20120731133527.GH4468@opensource.wolfsonmicro.com>
References: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
 <20120730165733.33e3ddfb@notabene.brown>
 <20120730133614.GA4468@opensource.wolfsonmicro.com>
 <20120731144724.5ef139fa@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731144724.5ef139fa@notabene.brown>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:47:24PM +1000, NeilBrown wrote:

> ... though it occurs to me that it is possible that the GPIO number might not
> be allocated until something else has been probed, so a -ve gpio number could
> mean "there is no such gpio" or it could mean "gpio has not been allocated
> yet".  I wonder if that should be allowed and where it should be handled.

If there's logic to do things like that I'd 

> I'd really like to see gpios be requested by name ... anyone know if there
> are any plans along that line?

I've not noticed anyone doing much substantial work on GPIO recently.
