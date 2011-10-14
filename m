Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab1JNTij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:38:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43476 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528Ab1JNTih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:38:37 -0400
Date: Fri, 14 Oct 2011 20:38:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 1/8] ASoC: da7210: bugfix for head phone
 volume control
Message-ID: <20111014193834.GN2931@opensource.wolfsonmicro.com>
References: <1318589725.12107.502.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318589725.12107.502.camel@matrix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:25:25PM +0530, Ashish Chavan wrote:
> This patch takes care of reserved bits of headphone volume
> register by using correct volume range.

Applied, thanks.
