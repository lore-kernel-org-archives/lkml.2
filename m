Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0LFMgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:36:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0LFMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:36:47 -0500
Subject: Re: [PATCH] ASoC: Hold client_mutex while calling
 snd_soc_instantiate_cards()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291625283.11404.2.camel@mola>
References: <1291625283.11404.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 12:36:42 +0000
Message-ID: <1291639002.3281.30.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 16:48 +0800, Axel Lin wrote:
> As the comments of snd_soc_instantiate_cards() said,
> snd_soc_instantiate_cards() must be called with client_mutex.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

