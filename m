Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0CXNvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:51:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51404 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0CXNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:51:51 -0400
Subject: Re: [patch] wm8994: playback => capture
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Joonyoung Shim <jy0922.shim@samsung.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100324115834.GG21571@bicker>
References: <20100324115834.GG21571@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 13:51:46 +0000
Message-ID: <1269438706.3798.53.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 14:58 +0300, Dan Carpenter wrote:
> Sparse caught that initialize "playback" two times instead of
> initializing "capture".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

