Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2FKC5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:57:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53917 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab2FKC5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:57:19 -0400
Date: Mon, 11 Jun 2012 03:57:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
	tps65911
Message-ID: <20120611025717.GE28211@opensource.wolfsonmicro.com>
References: <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com> <4FBBDA97.6000006@wwwdotorg.org> <4FBBDE06.5080806@nvidia.com> <4FC916AC.4060804@wwwdotorg.org> <4FD250DB.2090207@nvidia.com> <20120609030608.GF3924@opensource.wolfsonmicro.com> <4FD2CFE6.9070500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD2CFE6.9070500@wwwdotorg.org>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:24:06PM -0600, Stephen Warren wrote:
> On 06/08/2012 09:06 PM, Mark Brown wrote:

> > If we're going to do this we need to update all the existing DT bindings
> > for drivers that use single node regulators like this.  Please also
> > change the name used for the property to regulator-compatible to make it
> > clear that the idea is the same as normal compatible properties.

> I'm not sure of the logic behind naming the property
> "regulator-compatible"; the standard compatible property identifies that
> the node is of a particular type/class, whereas the regulator-id in the
> example Laxman quoted would indicate the specific identity/object. Those
> seem like different things.

They're both doing the same thing - up until you get the second register
compatible device a compatible binding is referencing a specific thing
too.  It's just saying "handle this like an X".
