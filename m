Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1HIPTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:19:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37044 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850Ab1HIPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:19:37 -0400
Date: Wed, 10 Aug 2011 00:19:24 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: Use int rather than size_t for lengths when
 logging blocks
Message-ID: <20110809151923.GG15861@opensource.wolfsonmicro.com>
References: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110810010847.77e916a7780ffddd98d91f68@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810010847.77e916a7780ffddd98d91f68@canb.auug.org.au>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:08:47AM +1000, Stephen Rothwell wrote:
> On Tue,  9 Aug 2011 17:00:04 +0900 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > x86_64 warns as size_t is not an int.

> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Stephen Rothwell <sfr@canb.auug.org.au>

> Reported-by?

Uh, yeah.  That.  Oops.
