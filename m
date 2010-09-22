Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0IVMr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:47:57 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55418 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0IVMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:47:56 -0400
Date: Wed, 22 Sep 2010 21:47:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, ralf@linux-mips.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] SOUND-OSS: Remove sh_dac_audio
Message-ID: <20100922124747.GD9546@linux-sh.org>
References: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
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

Since I thought I had already removed this ages ago but appear to have
been imagining things:

Acked-by: Paul Mundt <lethal@linux-sh.org>
