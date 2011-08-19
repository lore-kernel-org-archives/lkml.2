Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1HSV3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:29:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1HSV3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:29:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Fri, 19 Aug 2011 23:31:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110819234756.ef70fa07dccb6adc17d2f516@canb.auug.org.au>
In-Reply-To: <20110819234756.ef70fa07dccb6adc17d2f516@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192331.20553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, August 19, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (most of the arm and
> avr32 builds at least) failed like this:
> 
> In file included from drivers/base/power/clock_ops.c:14:
> include/linux/pm_clock.h:15: error: field 'nb' has incomplete type

Sorry about that.

> You need to include something that defines "struct notifier_block".

Right, should be fixed now.

Thanks,
Rafael
