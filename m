Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2ABNYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:24:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2ABNYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:24:06 -0500
Date: Mon, 2 Jan 2012 13:24:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: Enable supply regulator if child rail is
 enabled.
Message-ID: <20120102132403.GM4300@opensource.wolfsonmicro.com>
References: <1325489925-5148-1-git-send-email-ldewangan@nvidia.com>
 <20120102113623.GC2899@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9A78@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9A78@BGMAIL01.nvidia.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 05:37:04PM +0530, Laxman Dewangan wrote:

> > Why is this not in the changelog?

> I think this is in just different wording for explaining the change.

If something like this is worth saying it should be in the changelog so
that anyone finding the patch in git can see it too - in general stuff
after the --- should be things like differences from previous versions
of the patch or information about dependencies that need to be taken
care of when applying that don't matter once the patch is applied.
