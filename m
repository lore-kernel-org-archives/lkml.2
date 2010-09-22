Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0IVOQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:16:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0IVOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:16:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] SOUND-OSS: Remove sh_dac_audio
Date: Wed, 22 Sep 2010 16:15:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        ralf@linux-mips.org, Frederic Weisbecker <fweisbec@gmail.com>
References: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
In-Reply-To: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221615.42710.arnd@arndb.de>
X-Provags-ID: V02:K0:erBql4XM+bA+WG0HwXy/JzW0bP/dp7zYPj60GfNvhTB
 2EWJPbIcwHh/QdArwEpcJvIqmXsb5bQx0GLXrmX9ah/yTMYgBO
 aAH6xYk8atuOqwINy+vTygTkdZBANXEtvRmT4ZlejoC4+jOFDe
 q5wsvJQrDPRyjqvW4Haabnz9YlJL+7kIibvA4wnEtOUqo40TYy
 2J2cedWapuoAch+EZaprw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010, John Kacur wrote:
> Remove the SH DAC oss driver since there is an equivalent alsa driver.
> oss has been deprecated for years. Furthermore this driver has BKL code
> which we are trying to remove. Rather than attempt to fix this, simply
> remove the driver.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Takashi Iwai has already queued a patch from me to turn the BKL into a
driver specific mutex, the patch is now in linux-next.

There are still a few things that we may want to remove rather than
fix the BKL, but I don't think that's necessary here.

	Arnd
