Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2DXVIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:08:45 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43199 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2DXVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:08:43 -0400
Date: Tue, 24 Apr 2012 14:08:47 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dt: tegra_ventana: als and proximity sensor
 isl29018 support
Message-ID: <20120424210847.GA12611@quad.lixom.net>
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
 <1334645155-13799-4-git-send-email-ldewangan@nvidia.com>
 <4F8DF01D.9040900@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8DF01D.9040900@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:35:09PM -0600, Stephen Warren wrote:
> On 04/17/2012 12:45 AM, Laxman Dewangan wrote:
> > Add the device info for ALS and proximity sensor isl29018.
> 
> (There were a ton of irrelevant people CC'd on this patch; I cut them
> out, but kept the lists in case anyone was interested in the replies.
> The most relevant list, linux-tegra, also wasn't CC'd)
> 
> > diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts
> 
> > +		/* ALS and proximity sensor */
> 
> > +		isl29018: isl29018@44 {
> 
> I don't think the label "isl29018:" serves any purpose; nothing else
> needs to refer to this node.
> 
> I note from http://patchwork.ozlabs.org/patch/132936/ that:
> 
> a) Perhaps the vendor prefix should be "isil" not "isl". Olof, can you
> please comment here?

The standard practice is to use stock tickers, but if companies aren't public
then there isn't much you can do. Like Linus said, use your best judgement and
taste and that's really all we can ask for. :)



-Olof
