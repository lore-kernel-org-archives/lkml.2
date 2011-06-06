Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1FFSLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:11:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1FFSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:11:14 -0400
Message-ID: <4DED1A86.9030502@steinhoff.de>
Date: Mon, 06 Jun 2011 20:20:54 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Monica Puig-Pey <puigpeym@unican.es>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es> <4DEA1F22.6000603@unican.es> 	<4DEA255B.2050503@unican.es> <4DECBE44.2070803@unican.es>
In-Reply-To: <4DECBE44.2070803@unican.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:EqRu9wbGqS6j2lpBYoOR5Qf+iBp5wk/VBQ8mMabfmZD
 p5D6OwZdSbYea+gd+wQZAYlz7nPEiYHl+0qz8jP5Ibq/bfAB5S
 9wrNQOUeq3kVFi1m3EsT0fSd8hjM6PYaL9sdC9g/s8ntHuYDua
 DonLJztpA3IMTKdO6zzn621Ve11sJCgCMKqAFMgg4j9cW0UUDJ
 JVw5PUuHfC67k9lvOaskA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monica Puig-Pey wrote:
> I am writing a driver which has one kernel thread associated with it.
> I want to change the priority of this thread, so that I can specify 
> the order in which it is scheduled following an interrupt.
> I'm using:
>
>  sched_setscheduler(struct task_struct *, int, struct sched_param *);  
> -> sys_sched_setscheduler

http://ftp.au.debian.org/linux-mandocs/2.6.0-test7-full/sys_sched_setscheduler.html

Hope this helps ..

--Armin

>
> but it doesn't work. I tried to change the priority from the 
> init_module, and also from the Kernel Thread, but there is no way.
>
> Kernel version is 2.6.31-11-rt
>
> What do I call to change a kernel thread priority?
>
> Thanks you very much
>
> Mónica
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

