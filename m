Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2HFB7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:59:33 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48052 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755352Ab2HFB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:59:31 -0400
Message-ID: <501F24B5.5050600@xenotime.net>
Date: Sun, 05 Aug 2012 18:58:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christopher Sacchi <chris.sacchi@gmail.com>
CC: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Mac80211 Driver patch
References: <CAGh4K3+RODO0zuDThZKKzBCLexXa1M7qYVUu6knciruZ0KWGRQ@mail.gmail.com>
In-Reply-To: <CAGh4K3+RODO0zuDThZKKzBCLexXa1M7qYVUu6knciruZ0KWGRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 06:52 PM, Christopher Sacchi wrote:

> Patch for Mac80211, and no this is not spam, so do not ignore my
> e-mails. This is a patch, so copy this into your favorite text editor
> and save it as test.patch. Let the maintainers read and know! By the
> way, it is under the first -- line and to the 2nd to last line. :)
> --


You won't need to say where the patch is if you will read and follow
Documentation/SubmittingPatches .

> --- main.c	2012-07-21 20:58:29.000000000 +0000
> +++ mainnew.c	2012-08-05 20:00:37.000000000 +0000
> @@ -32,7 +32,7 @@
>  #include "led.h"
>  #include "cfg.h"
>  #include "debugfs.h"
> -
> +#include "net/rfkill/rfkill.h"
>  static struct lock_class_key ieee80211_rx_skb_queue_class;
> 
>  void ieee80211_configure_filter(struct ieee80211_local *local)
> @@ -183,6 +183,7 @@
>  		 *
>  		 */
>  		/* WARN_ON(ret); */
> +		WARN_ON(1)


Does that build without a problem?
or is it missing a ';' ??

>  	}
> 
>  	return ret;
> --



-- 
~Randy
