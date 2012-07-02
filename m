Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2GBT6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:58:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2GBT6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:58:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
Date: Mon, 2 Jul 2012 22:04:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        "Lists Linaro-dev" <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>
References: <4FDEE98D.7010802@linaro.org> <4FDF2D58.9010006@ti.com> <4FE86727.5010400@linaro.org>
In-Reply-To: <4FE86727.5010400@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207022204.15539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, June 25, 2012, Daniel Lezcano wrote:
> 
> Hi Stephen,
> 
> we discussed last week to put in place a tree grouping the cpuidle
> modifications [1]. Is it possible to add the tree ?
> 
> git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next
> 
> It contains for the moment Colin Cross's cpuidle coupled states.

Do you have a stable branch in that tree, i.e. such that it is guaranteed not
to be rebased?

Rafael
