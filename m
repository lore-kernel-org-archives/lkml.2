Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab0FJJQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:16:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab0FJJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:16:04 -0400
Date: Thu, 10 Jun 2010 11:16:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, mingo@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Eric W.Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] fix hwmon/i5k_amb.c sysfs attribute for lockdep
In-Reply-To: <20100609110719.270634a9@hyperion.delvare>
Message-ID: <alpine.LNX.2.00.1006101115230.12271@pobox.suse.cz>
References: <20100609140000.60975b2f.kamezawa.hiroyu@jp.fujitsu.com> <20100609110719.270634a9@hyperion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Jean Delvare wrote:

> On Wed, 9 Jun 2010 14:00:00 +0900, KAMEZAWA Hiroyuki wrote:
> > I'm not familiar with this area but I need this patch for lockdep in mmotm.
> > please check.
> > -Kame
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > i5k_amb.ko uses dynamically allocated memory (by kmalloc) for
> > attributes passed to sysfs. So, sysfs_attr_init() should be called
> > for working happy with lockdep.
> 
> Such a fix is needed, yes. I though Jiri was working on it... Jiri?

It's still on my TODO list, but I haven't gotten to it yet. So whoever 
beats me up fixing it, please merge that. Thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
