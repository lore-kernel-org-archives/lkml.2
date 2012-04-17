Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2DQQEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab2DQQEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:04:50 -0400
Message-ID: <4F8D9457.2080900@redhat.com>
Date: Tue, 17 Apr 2012 13:03:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, trivial@kernel.org,
        kjsisson@bellsouth.net, Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ben Dooks <ben@simtec.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Andy Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josua Dietze <digidietze@draisberghof.de>,
        Andiry Xu <andiry.xu@amd.com>, Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] [Trivial] Documentation: Add newline at end-of-file to
 files lacking one
References: <alpine.LNX.2.00.1204162329190.21898@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204162329190.21898@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-04-2012 18:35, Jesper Juhl escreveu:
> This patch simply adds a newline character at end-of-file to those
> files in Documentation/ that currently lack one.
> 
> This is done for a few different reasons:
> 
> A) It's rather annoying when you do "cat some_file.txt" that your
>    prompt/cursor ends up at the end of the last line of output rather
>    than on a new line.
> 
> B) Some tools that process files line-by-line may get confused by the
>    lack of a newline on the last line.
> 
> C) The "\ No newline at end of file" line in diffs annoys me for some
>    reason.
> 
> So, let's just add the missing newline once and for all.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

>  Documentation/dvb/opera-firmware.txt                           |    2 +-
>  Documentation/video4linux/cpia2_overview.txt                   |    2 +-
>  Documentation/video4linux/stv680.txt                           |    2 +-

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
