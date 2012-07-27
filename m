Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2G0D5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:57:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64857 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2G0D5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <1343361129-8802-1-git-send-email-dev@snitselaar.org>
References: <1343361129-8802-1-git-send-email-dev@snitselaar.org>
Date: Thu, 26 Jul 2012 20:57:35 -0700
Message-ID: <CA+30oubMM0AVqH2PP+3mDcwjPMR9OXxUTdBcE5bRNCv8C6TPfw@mail.gmail.com>
Subject: Re: [PATCH] watchdog: watchdog-test: make term() static
From: Jerry Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:52 PM, Jerry Snitselaar <dev@snitselaar.org> wrote:
> In 3.5 warning during build 'no previous prototype for term'. Since it
> is only used in watchdog-test.c make term() static.
>
> Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
> ---
>  Documentation/watchdog/src/watchdog-test.c | 2 +-
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
> --
> 1.7.12.rc0
>

Disregard this patch. I didn't see Randy's patch when I did a search
in my email.

Jerry
