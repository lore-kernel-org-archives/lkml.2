Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2EHPOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:14:34 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44901 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2EHPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:14:33 -0400
Message-ID: <4FA9382A.9090709@candelatech.com>
Date: Tue, 08 May 2012 08:13:46 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cristian Chilipirea <cristian.chilipirea@gmail.com>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.baluta@gmail.com
Subject: Re: [PATCH] ipv4: Fixed checkpatch warnings and errors
References: <1336474704-9366-1-git-send-email-cristian.chilipirea@gmail.com>
In-Reply-To: <1336474704-9366-1-git-send-email-cristian.chilipirea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:58 AM, Cristian Chilipirea wrote:
> Fixed warnings and errors in af_inet.c.

>   #ifdef CONFIG_COMPAT
> -static int inet_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
> +static int inet_compat_ioctl(struct socket *sock, unsigned int cmd,
> +		unsigned long arg)
>   {

That is so much worse than what was there before.

Lets stop useless checkpatch crap on existing code
unless it's really ugly.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

