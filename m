Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0GMKpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:45:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54922 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0GMKpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:45:53 -0400
Subject: Re: [PATCH 34/36] sound/soc/blackfin: Remove unnecessary casts of
 private_data
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
In-Reply-To: <1c7c609ba4910da572c7888069707548af187651.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	 <1c7c609ba4910da572c7888069707548af187651.1278967121.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 11:45:48 +0100
Message-ID: <1279017948.3125.40.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Fwiw, we are getting rid of the void * private_data in the ASoC
multi-component patch series and will use dev_get_drvdata() style
accessors.

Both ASoC patches

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

