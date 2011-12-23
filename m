Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1LWA3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:29:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1LWA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:29:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (pm tree related)
Date: Fri, 23 Dec 2011 01:32:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111222162846.51beb2e1b6b5c6ff2378ad33@canb.auug.org.au>
In-Reply-To: <20111222162846.51beb2e1b6b5c6ff2378ad33@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112230132.58765.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 22, 2011, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> drivers/base/bus.o: In function `dev_pm_qos_add_ancestor_request':
> bus.c:(.text+0x4c0): multiple definition of `dev_pm_qos_add_ancestor_request'
> drivers/base/core.o:core.c:(.text+0x8ec): first defined here
> drivers/base/dd.o: In function `dev_pm_qos_add_ancestor_request':
> dd.c:(.text+0x418): multiple definition of `dev_pm_qos_add_ancestor_request'
> drivers/base/core.o:core.c:(.text+0x8ec): first defined here
> kernel/sysctl_binary.o: In function `dev_pm_qos_add_ancestor_request':
> sysctl_binary.c:(.text+0x124): multiple definition of `dev_pm_qos_add_ancestor_request'
> 
> Caused by commit 513dcbda6199 ("PM / QoS: Introduce
> dev_pm_qos_add_ancestor_request()") from the pm tree.
> 
> Please build with and without config options that protect new code ... :-(

My bad, sorry.

This issue should be fixed in my linux-next branch now.

Thanks,
Rafael
