Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2H2PsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:48:11 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:44279 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753955Ab2H2PsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:48:05 -0400
Message-ID: <503E39A5.9090903@xenotime.net>
Date: Wed, 29 Aug 2012 08:47:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: yan <clouds.yan@gmail.com>
CC: wim@iguana.be, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] watchdog: fix a compiler warning of test program
References: <1346247545-3433-1-git-send-email-clouds.yan@gmail.com>
In-Reply-To: <1346247545-3433-1-git-send-email-clouds.yan@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 06:39 AM, yan wrote:

> This patch fixs the following compiler warning:
> 


Hi,
This is already fixed in the watchdog git tree.

Thanks.

> Documentation/watchdog/src/watchdog-test.c:34:6: \
> warning: no previous prototype for ‘term’ [-Wmissing-prototypes]
> 
> Signed-off-by: yan <clouds.yan@gmail.com>
> ---
>  Documentation/watchdog/src/watchdog-test.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
> index 73ff5cc..3da8229 100644
> --- a/Documentation/watchdog/src/watchdog-test.c
> +++ b/Documentation/watchdog/src/watchdog-test.c
> @@ -31,7 +31,7 @@ static void keep_alive(void)
>   * or "-e" to enable the card.
>   */
>  
> -void term(int sig)
> +static void term(int sig)
>  {
>      close(fd);
>      fprintf(stderr, "Stopping watchdog ticks...\n");



-- 
~Randy
