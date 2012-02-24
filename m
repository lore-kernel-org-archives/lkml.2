Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2BXX3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:29:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47971 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2BXX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:29:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.130.138 as permitted sender) smtp.mail=glikely@secretlab.ca
Date: Fri, 24 Feb 2012 16:29:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] gpio: tegra: Fix build issue due to irq_domain rework.
Message-ID: <20120224232942.GL25293@ponder.secretlab.ca>
References: <1329175275-19404-1-git-send-email-swarren@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCE0C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCE0C@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 03:12:37PM -0800, Stephen Warren wrote:
> Stephen Warren wrote at Monday, February 13, 2012 4:21 PM:
> > Commit 7da5a66 "irq_domain: Remove 'new' irq_domain in favour of the
> > ppc one" changed the set of available irq domain APIs. Update the Tegra
> > GPIO driver to account for those changes, to solve a build break.
> 
> Grant, Linus,
> 
> Could this please be checked in; linux-next since about Feb 6th doesn't
> build for Tegra without it.

This doesn't apply against the gpio tree since I didn't pick up the DT patches.
It looks like Olof did.  (3391811c & 6f74dc9bc).  The irq_domain branch is
stable now, so it can be merged into the arm-soc tree before applying this
patch.

g.

