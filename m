Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1FPTO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:14:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35271 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab1FPTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:14:27 -0400
Date: Thu, 16 Jun 2011 12:14:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Hans Petter Selasky <hselasky@c2i.net>
Subject: Re: [PATCH] DVB: dvb-net, make the kconfig text helpful
Message-Id: <20110616121402.2e7441af.randy.dunlap@oracle.com>
In-Reply-To: <1308251216-8194-1-git-send-email-jslaby@suse.cz>
References: <4DF9DD25.1000103@redhat.com>
	<1308251216-8194-1-git-send-email-jslaby@suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DFA5605.0079:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 21:06:56 +0200 Jiri Slaby wrote:

> Telling the user they can disable an option if they want is not the
> much useful. Describe what it is good for instead.
> 
> The text was derived from Mauro's email.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Petter Selasky <hselasky@c2i.net>

Yes, much better.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  drivers/media/Kconfig |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index dc61895..279e2b9 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -89,11 +89,13 @@ config DVB_NET
>  	default (NET && INET)
>  	depends on NET && INET
>  	help
> -	  The DVB network support in the DVB core can
> -	  optionally be disabled if this
> -	  option is set to N.
> +	  This option enables DVB Network Support which is a part of the DVB
> +	  standard. It is used, for example, by automatic firmware updates used
> +	  on Set-Top-Boxes. It can also be used to access the Internet via the
> +	  DVB card, if the network provider supports it.
>  
> -	  If unsure say Y.
> +	  You may want to disable the network support on embedded devices. If
> +	  unsure say Y.
>  
>  config VIDEO_MEDIA
>  	tristate
> -- 
> 1.7.5.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
