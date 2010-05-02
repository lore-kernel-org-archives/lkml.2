Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0EBN3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:29:54 -0400
Received: from t23.t-2.net ([84.255.209.102]:59731 "EHLO t23.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab0EBN3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:29:52 -0400
Subject: Re: [PATCH] console logging detour via printk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BDD4CD7.2060205@gmail.com>
References: <1272664980.10241.77.camel@itpsd6lap>
	 <20100501120418.6fca2aad@lxorguk.ukuu.org.uk>
	 <1272739689.2147.156.camel@itpsd6lap>  <4BDD4CD7.2060205@gmail.com>
Content-Type: text/plain
Date: Sun, 02 May 2010 15:29:47 +0200
Message-Id: <1272806987.2155.34.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100502132949Z4070t23.t-2.net 1O8ZEz-00013e-IT
X-SGG-RESULT: 20100502132949Z4070t23.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 02.05.2010 (ned) ob 11:58 +0200 je Marco Stornelli zapisal(a):
> 01/05/2010 20:48, Samo Pogacnik wrote:
> > Dne 01.05.2010 (sob) ob 12:04 +0100 je Alan Cox zapisal(a):
> >>> while i was searching for effective logging of complete console output
> >>> produced by the kernel and user phase of the boot process, it turned out
> >>> that only kernel messages imho get systematically cached and stored into
> >>> log files (if needed). All userspace processes are on their own to use
> >>> syslog, which is fine, but there are also many console messages
> >>> reporting the boot status via init scripts, .... I came across the
> >>> bootlogd daemo, which handles the job of redirecting console output into
> >>> a log file, but i find it problematic to use especialy, when using
> >>> initial ram disk image.
> >>
> >> So you want to patch the kernel because you can't work out how to do this
> >> in userspace ? The distributions seem to have no problem doing this in
> >> user space that I can see. It doesn't seem to be a hard user space
> >> problem, and there are a ton of things you want to do with this sort of
> >> stuff (like network logging) that you can't do in kernel space.
> > 
> > The distros have no problem logging complete console output into log
> > files or over the network, because they simply do not do it at least for
> > the initrd part of the boot process (i'd be glad, if i'm wrong). 
> 
> Mmm...It's an interesting problem. I see in my distro (openSuse) a
> script called boot.klog that it seems to perform that (even initrd
> part). In the file boot.msg I can see the initial prints of the kernel
> and user space scripts.
> 
Thanks for the info. 
Is this boot.klog script from the initrd image or from the real rootfs?
As you can see, i am still suspicious about the initrd part user console
messages:)

Samo

