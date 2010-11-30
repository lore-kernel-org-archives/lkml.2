Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0K3PPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:15:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0K3PPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:15:43 -0500
Subject: Re: [PATCH] regulator: Add and use rdev_<level> macros
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291125228.18026.32.camel@Joe-Laptop>
References: <20101129220046.GB8335@opensource.wolfsonmicro.com>
	 <3c50480be4c6fe95a01d79e3c95fba0d9175a81b.1291079473.git.joe@perches.com>
	 <20101130105205.GA7403@rakim.wolfsonmicro.main>
	 <1291125228.18026.32.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:15:39 +0000
Message-ID: <1291130139.3293.18.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 05:53 -0800, Joe Perches wrote:
> On Tue, 2010-11-30 at 10:52 +0000, Mark Brown wrote:
> > On Mon, Nov 29, 2010 at 05:12:56PM -0800, Joe Perches wrote:
> > > Just to please broonie...
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > As usual when fixing review issues please revise your original patch
> > rather than posting a fresh patch.
> 
> Here's an earlier comment:
> 
> On Thu, 2010-11-18 at 13:30 +0000, Mark Brown wrote:
> > This looks reasonable, please rebase on top of Daniel's patches and
> > submit it properly (with changelog and so on). 
> 
> Sometimes it's simpler for an upstream maintainer to do
> something like:
> 
> git am -s <patch1.mbox>
> patch -p1 < patch2.mbox
> git commit --amend file
> 
> instead of back and forthing.
> 
> ---
> Use rdev_<level> convenience macros to emit rdev_get_name(rdev)
> along with whatever format/arg... is supplied.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/regulator/core.c |  146 ++++++++++++++++++++-------------------------
>  1 files changed, 65 insertions(+), 81 deletions(-)
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

