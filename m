Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab0GPUCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:02:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52448 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181Ab0GPUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=shZqHDCtC2dO8n4nI0pejmxtsx2Iq/M2cyoPVlikJgL6gx3vlWJKMuujpJif7DmSFS
         QFsd8O3GlohBiv2vCij5ikn7uUCdlITbANOmyUDKDOI3CrCL0q6Iwf8bzpln5R6K91x2
         FBvr3zXTFzMAzxzm87XIE6oDbgi7BriZ9dPQc=
Message-ID: <4C40BAD1.8090908@garzik.org>
Date: Fri, 16 Jul 2010 16:02:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: linux-kbuild@vger.kernel.org, nico-linuxsetlocalversion@schottelius.org,
        linux-kernel@vger.kernel.org
Subject: Re: I did a git pull and a plus appeared
References: <20100716121802.65fdfa24@lembas.zaitcev.lan>
In-Reply-To: <20100716121802.65fdfa24@lembas.zaitcev.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 02:18 PM, Pete Zaitcev wrote:
> Dear All:
>
> I have a tree that existed for a few years (a clone of Linus' tree).
> Today I did a git pull in it, and a plus appeared in the built version.
> E.g. after "make modules_install":
>
> [root@niphredil linux-2.6-tip]# ls /lib/modules/
> 2.6.33.1-19.fc13.x86_64  2.6.34-rc6-tip                    2.6.35-rc1-tip
> 2.6.34-43.fc14.x86_64    2.6.35-0.36.rc4.git5.fc14.x86_64  2.6.35-rc5-tip+
> [root@niphredil linux-2.6-tip]#
>
> How do I get rid of the plus? I have (had for a long time):
>
> [zaitcev@niphredil linux-2.6-tip]$ grep LOCAL .config
> CONFIG_LOCALVERSION="-tip"
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_X86_LOCAL_APIC=y
> [zaitcev@niphredil linux-2.6-tip]$

Is the '+' listed at the top of the toplevel Makefile?

	Jeff



