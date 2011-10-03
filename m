Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1JCNP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:15:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44786 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab1JCNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:15:51 -0400
Date: Mon, 3 Oct 2011 14:15:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: txx9: Add __exit_p at necessary place
Message-ID: <20111003131549.GG3731@opensource.wolfsonmicro.com>
References: <1317605912.2588.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317605912.2588.0.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:38:32AM +0800, Axel Lin wrote:
> We have __exit annotation for txx9aclc_generic_remove(),
> thus add __devexit_p to wrap it.

Applied, thanks.
