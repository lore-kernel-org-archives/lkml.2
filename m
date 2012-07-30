Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2G3PrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:47:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875Ab2G3PrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:47:09 -0400
Date: Mon, 30 Jul 2012 16:47:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120730154706.GL4468@opensource.wolfsonmicro.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <5016ABDD.5010809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016ABDD.5010809@gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:44:29AM -0500, Rob Herring wrote:
> On 07/27/2012 07:05 AM, Alexandre Courbot wrote:

> > +		power-on-sequence {
> > +			regulator@0 {
> > +				id = "power";
> > +				enable;

> What do this mean? Isn't this implied for a regulator?

I assume you might have some sequences which need some things to be
turned off for some reason; it at least seems to be something you'd want
to design for.

> This looks like you designed the platform_data structs first and then
> came up with device nodes to mirror the struct.

Judging by most of the DT I review this seems idiomatic :)
