Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab1FFTQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:16:12 -0400
Received: from in.cluded.net ([195.159.98.120]:33372 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1FFTQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:16:11 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 15:16:10 EDT
Message-ID: <4DED25AD.9050504@uw.no>
Date: Mon, 06 Jun 2011 19:08:29 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/9] kconfig: annotate non-trivial fall-trough
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com> <1307386711-8866-2-git-send-email-lacombar@gmail.com>
In-Reply-To: <1307386711-8866-2-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Lacombe wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/conf.c     |    4 ++++
>  scripts/kconfig/confdata.c |    5 +++++
>  scripts/kconfig/gconf.c    |    1 +
>  scripts/kconfig/mconf.c    |    1 +
>  4 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 006ad81..8be7374 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -106,6 +106,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
>  			return 0;
>  		}
>  		check_stdin();
> +		/* FALLTHOUGH */
>  	case oldaskconfig:
>  		fflush(stdout);
>  		xfgets(line, 128, stdin);

Could it be done using the inside voice?

s/FALLTHOUGH/fall through/


Daniel K.
