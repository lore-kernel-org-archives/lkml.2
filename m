Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2GBTtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:49:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2GBTtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:49:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Build failures in -next due to move of disable
Date: Mon, 2 Jul 2012 21:54:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120702123740.GA11168@sirena.org.uk>
In-Reply-To: <20120702123740.GA11168@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207022154.35327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 02, 2012, Mark Brown wrote:
> Today's -next is failing to build for me because commit 9f419c (PM /
> Domains: Add preliminary support for cpuidle) and commit b32e30
> (cpuidle: move field disable from per-driver to per-cpu) disagree about
> where the disable field should be:

Hmm, do you know what tree commit b32e30 comes from?

Rafael


> 
>   CC      drivers/base/power/domain.o
> drivers/base/power/domain.c: In function '__pm_genpd_poweron':
> drivers/base/power/domain.c:194: error: 'struct cpuidle_state' has no member named 'disable'
> drivers/base/power/domain.c: In function 'pm_genpd_poweroff':
> drivers/base/power/domain.c:490: error: 'struct cpuidle_state' has no member named 'disable'
> drivers/base/power/domain.c: In function 'genpd_attach_cpuidle':
> drivers/base/power/domain.c:1671: error: 'struct cpuidle_state' has no member named 'disable'
> drivers/base/power/domain.c: In function 'genpd_detach_cpuidle':
> drivers/base/power/domain.c:1706: error: 'struct cpuidle_state' has no member named 'disable'
> 
> 

