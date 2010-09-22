Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0IVO5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:57:40 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46370 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IVO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:57:39 -0400
Date: Wed, 22 Sep 2010 15:57:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] SOUND-OSS: Remove sh_dac_audio
Message-ID: <20100922145737.GA12663@linux-mips.org>
References: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 01:47:01PM +0200, John Kacur wrote:

> Remove the SH DAC oss driver since there is an equivalent alsa driver.
> oss has been deprecated for years. Furthermore this driver has BKL code
> which we are trying to remove. Rather than attempt to fix this, simply
> remove the driver.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

No idea why I was cc'ed as I have no interested in the driver but certainly
support the motivation behind the patch:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
