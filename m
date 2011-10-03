Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1JCNQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:16:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55936 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab1JCNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:16:38 -0400
Date: Mon, 3 Oct 2011 14:16:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Ben Dooks <ben@simtec.co.uk>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Staticise simtec_audio_resume()
Message-ID: <20111003131636.GJ3731@opensource.wolfsonmicro.com>
References: <1317629512.2820.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317629512.2820.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:11:52PM +0800, Axel Lin wrote:
> It is exported via resume callback of struct dev_pm_ops rather than referenced
> directly and so should be staticised.

Applied, thanks.
