Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1FFJX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:23:26 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:40431 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1FFJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:23:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DEC9E6B.8030505@cam.ac.uk>
Date: Mon, 06 Jun 2011 10:31:23 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: perex@perex.cz, tiwai@suse.de, broonie@opensource.wolfsonmicro.com,
        dp@opensource.wolfsonmicro.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm8940: remove unecessary if statement
References: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1307321274-21858-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 01:47, Greg Dietsche wrote:
> the code always returns ret regardless, so if(ret) check is unecessary.
Good point, though please spell check your commit messages.
unecessary -> unnecessary

Also if you want to do this sort of cleanup, please also fix the
equivalent in wm8940_resume and wm8940_add_widgets.  Ack is for
what is here, plus those if you do them.

Just as an aside, there is no earthly point in cc'ing lkml for a
simple cleanup like this. Just adds to already huge amount of noise!
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  sound/soc/codecs/wm8940.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
> index 25580e3..1ada6d3 100644
> --- a/sound/soc/codecs/wm8940.c
> +++ b/sound/soc/codecs/wm8940.c
> @@ -730,9 +730,6 @@ static int wm8940_probe(struct snd_soc_codec *codec)
>  	if (ret)
>  		return ret;
>  	ret = wm8940_add_widgets(codec);
> -	if (ret)
> -		return ret;
> -
>  	return ret;
>  }
>  

