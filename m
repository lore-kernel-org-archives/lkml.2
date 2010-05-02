Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0EBKBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 06:01:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62628 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab0EBKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 06:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I042uWDiC3+2BxSuPllVxgV2XZwwnOfBTmOOk8O9qO8JDO1+7s2Go/qcDwYzrz09C5
         s8EGWbGgUPcZk34BhmqV/nmM5B2kWOcrXFOQvcZu9YLhpFVNR00uFglulzDuqzfHpTvk
         tqt2aonmmkIlervAYBM+2xPdGYnZdNMhULEs0=
Message-ID: <4BDD4CD7.2060205@gmail.com>
Date: Sun, 02 May 2010 11:58:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Samo Pogacnik <samo_pogacnik@t-2.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console logging detour via printk
References: <1272664980.10241.77.camel@itpsd6lap>	 <20100501120418.6fca2aad@lxorguk.ukuu.org.uk> <1272739689.2147.156.camel@itpsd6lap>
In-Reply-To: <1272739689.2147.156.camel@itpsd6lap>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01/05/2010 20:48, Samo Pogacnik wrote:
> Dne 01.05.2010 (sob) ob 12:04 +0100 je Alan Cox zapisal(a):
>>> while i was searching for effective logging of complete console output
>>> produced by the kernel and user phase of the boot process, it turned out
>>> that only kernel messages imho get systematically cached and stored into
>>> log files (if needed). All userspace processes are on their own to use
>>> syslog, which is fine, but there are also many console messages
>>> reporting the boot status via init scripts, .... I came across the
>>> bootlogd daemo, which handles the job of redirecting console output into
>>> a log file, but i find it problematic to use especialy, when using
>>> initial ram disk image.
>>
>> So you want to patch the kernel because you can't work out how to do this
>> in userspace ? The distributions seem to have no problem doing this in
>> user space that I can see. It doesn't seem to be a hard user space
>> problem, and there are a ton of things you want to do with this sort of
>> stuff (like network logging) that you can't do in kernel space.
> 
> The distros have no problem logging complete console output into log
> files or over the network, because they simply do not do it at least for
> the initrd part of the boot process (i'd be glad, if i'm wrong). 

Mmm...It's an interesting problem. I see in my distro (openSuse) a
script called boot.klog that it seems to perform that (even initrd
part). In the file boot.msg I can see the initial prints of the kernel
and user space scripts.

Marco
