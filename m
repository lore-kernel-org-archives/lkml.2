Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0GUMFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:05:33 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:39994 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0GUMFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:05:32 -0400
Message-ID: <4C46E289.6010009@grupopie.com>
Date: Wed, 21 Jul 2010 13:05:29 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17]Documentation/blockdev/paride.txt update web address.
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com> <1279687926-29360-2-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1279687926-29360-2-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> The patch below removes a web address due to me being unable
> to locate this at all. If anybody knows the location let
> me know and I'll resend.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  Documentation/blockdev/paride.txt |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/blockdev/paride.txt b/Documentation/blockdev/paride.txt
> index e431267..11c4e3f 100644
> --- a/Documentation/blockdev/paride.txt
> +++ b/Documentation/blockdev/paride.txt
> @@ -409,9 +409,4 @@ the list manager is a robot that will subscribe you using the reply
>  address in your mail headers.  REMOVE any anti-spam gimmicks you may
>  have in your mail headers, when sending mail to the list server.
>  
> -You might also find some useful information on the linux-parport
> -web pages (although they are not always up to date) at
> -
> -	http://www.torque.net/parport/
> -

I don't think removing an address like this is the best option. At least
having the "old" address allows me to go to www.archive.org and find out
a lot of useful information.

Maybe just marking it as "(dead link)" and warning the respective
maintainer would be better?

-- 
Paulo Marques - www.grupopie.com

"I used to be indecisive, but now I'm not so sure."
