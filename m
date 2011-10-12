Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1JLPBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:01:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54090 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab1JLPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:01:07 -0400
Date: Wed, 12 Oct 2011 16:01:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 6/9] ASoC: da7210: bugfix for head phone
 volume control
Message-ID: <20111012150101.GS3647@opensource.wolfsonmicro.com>
References: <1318431934.12107.421.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318431934.12107.421.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:35:34PM +0530, Ashish Chavan wrote:
> This patch takes care of reserved bits of headphone volume
> register by using correct volume range.

This doesn't apply, which is pretty surprising given that there's no
obvious overlap at all with the rest of the code.

> Tested on Samsung SMDK6410 board with DA7210 evaluation board.

This really isn't useful information in a changelog, apart from anything
else this isn't going to be a system that it's easy for other people to
reproduce.
