Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0ELIrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:47:23 -0400
Received: from mail4.comsite.net ([205.238.176.238]:56695 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0ELIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:47:21 -0400
X-Greylist: delayed 995 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 04:47:21 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.98.68;
From: Milton Miller <miltonm@bga.com>
Subject: Re: cpumask: fix compat getaffinity
To: Arnd Bergmann <arnd@arndb.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
In-Reply-To: <201005112013.56392.arnd@arndb.de>
X-Mailer: vi
References: <201005112013.56392.arnd@arndb.de>
 <201005081111.08720.arnd@arndb.de>
 <20100511104334.E572.A69D9226@jp.fujitsu.com>
 <20100511031354.GA9327@kroah.com>
Date: Wed, 12 May 2010 03:30:45 -0500
X-Originating-IP: 71.22.98.68
Message-ID: <1273653045_3386@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At least for parsing, we need to allocate and parse NR_CPUS until
all places like arch/powerpc/platforms/pseries/xics.c that compare a
user-supplied mask to CPUMASK_ALL are eliminated.


> Would it make sense to use my initial patch for -stable, which reverts
> the ABI back to before the change that caused the problem, but apply
> the correct fix (changing the ABI throughout) for future releases?

This would definitly be the conservative fix.

milton
