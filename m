Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2ABMaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:30:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38366 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2ABMaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:30:01 -0500
Date: Mon, 2 Jan 2012 12:29:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] use devm_ functions
Message-ID: <20120102122957.GL2899@opensource.wolfsonmicro.com>
References: <1325177489-13815-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325177489-13815-1-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 05:51:19PM +0100, Julia Lawall wrote:
> The following is a semantic patch (http://coccinelle.lip6.fr/) that
> introduces uses of various devm_ functions.  The main strategy is

Applied all except the jz4740 patch which Axel already did, thanks.
