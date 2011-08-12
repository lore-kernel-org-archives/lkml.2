Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1HLAMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:12:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63330 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1HLAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:12:51 -0400
Message-ID: <4E447000.8070505@gmail.com>
Date: Fri, 12 Aug 2011 02:12:48 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Tonda <as@strmilov.cz>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: TCP port firewall controlled by UDP packets
References: <1313106969-18733-1-git-send-email-as@strmilov.cz>
In-Reply-To: <1313106969-18733-1-git-send-email-as@strmilov.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 01:56 AM, Tonda wrote:
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -624,3 +624,7 @@
>  	  on the Internet.
>  
>  	  If unsure, say N.
> +
> +config TCPFIREWALL
> +	tristate "TCP Firewall controlled by UDP queries"
> +	depends on m

And netfilter doesn't work why?
Also, thanks to the foreign variable names, I have absolutely no clue what the code does. ;)

~Maarten
