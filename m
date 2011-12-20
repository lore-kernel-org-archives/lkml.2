Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1LTLyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:54:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60712 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1LTLyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:54:43 -0500
Date: Tue, 20 Dec 2011 11:54:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 19
Message-ID: <20111220115439.GM2866@opensource.wolfsonmicro.com>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
 <20111220015235.GB8290@sirena.org.uk>
 <20111220142048.eeccb51ed290d8223ba2c580@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220142048.eeccb51ed290d8223ba2c580@canb.auug.org.au>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 02:20:48PM +1100, Stephen Rothwell wrote:

> Which I reported to you on Dec 15 (along with another build error in the
> regulator tree that you have fixed).  You even created a patch to fix it
> (Subject: [PATCH] mfd: Declare da9052_regmap_config for the bus drivers)
> but that has not appeared in your tree yet.

Pushed now, I had obviously thought the patch was pushed into my tree
and obviously everything was working locally.
