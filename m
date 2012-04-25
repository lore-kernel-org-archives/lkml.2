Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2DYEY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:24:28 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:1330 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2DYEY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:24:27 -0400
Date: Wed, 25 Apr 2012 14:20:01 +1000
From: Chris Jones <chrisjones@spin.net.au>
To: NeilBrown <neilb@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.1+ kernels unbootable
Message-ID: <20120425142001.2cb7a79e@ubuntu>
In-Reply-To: <20120425132122.11280b66@notabene.brown>
References: <20120425124925.267056b5@ubuntu>
	<20120425132122.11280b66@notabene.brown>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 13:21:22 +1000
NeilBrown <neilb@suse.de> wrote:

> You might like to try 
>  a/ describing your current system in more detail.
>  b/ describe what actually happens when you try to boot a 3.1+ kernel.
>     It is rare that absolutely nothing happens.
>     Also describe the provenance of these 3.1+ kernels (do you compile
>     yourself, or get them from a distro or....)
> 
> NeilBrown


Thanks Neil. I use standard x86_64 Intel CPU system with 2.0GB DDRII
RAM on a Gigabyte GA-8VM800PMD-775-RH motherboard.

This happens on both Ubuntu and Fedora kernels. And in fact, any kernel
3.1 or above. It's not only very odd, but also very annoying.

I get to the boot screen and when I select ENTER to boot into the
system, my screen goes black and then the system reboots. It's
definitely a kernel issue as anything (as mentioned already) with
kernel 3.0 or below works just fine.


Regards

Chris Jones
