Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2LQUhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:37:35 -0500
Received: from mail-wg0-f66.google.com ([74.125.82.66]:54250 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2LQUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:37:33 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: Add Save/Load buttons
Date: Mon, 17 Dec 2012 21:37:26 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.10-treguer; KDE/4.4.5; x86_64; ; )
Cc: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
References: <20121217145604.GB17427@udknight>
In-Reply-To: <20121217145604.GB17427@udknight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212172137.27241.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Monday 17 December 2012 Wang YanQing wrote:
> If menuconfig have Save/Load button like alternative
> .config editors, xconfig, nconfig, etc.We will have
> a obvious benefit when use menuconfig just like
> when we use others, we can Save/Load our .config quickly
> and conveniently.
> 
> This patch add the Save/Load button for menuconfig.
> 
> [remove trailing space while at it for below line:
> "*)  Formerly when I used Page Down and Page Up, the cursor would be set"
> ]
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
[--SNIP--]
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 53975cf..c074f8a 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
[--SNIP--]
> @@ -702,6 +709,17 @@ static void show_helptext(const char *title, const char *text)
>  	show_textbox(title, text, 0, 0);
>  }
>  
> +static void conf_message_callback(const char *fmt, va_list ap)
> +{
> +	char buf[1024];

char buf[PATH_MAX+1];

[--SNIP--]
> @@ -948,4 +968,3 @@ int main(int ac, char **av)
>  
>  	return res;
>  }
> -

Spurious empty-line removal. Don't.

Otherwise, I've tested it, and it works great! :-)
Care to repost with the changes above (wait a bit in case of more review
by others), and you'll get my tst-by and rev'ed-by tags.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

