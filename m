Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1AMQEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:04:02 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:46750 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757156Ab1AMQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:04:00 -0500
Date: Thu, 13 Jan 2011 17:03:37 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 7/7] ptrace: clean transitions between TASK_STOPPED and
 TRACED
Message-ID: <20110113160337.GA14383@host1.dyn.jankratochvil.net>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <1293199257-11255-8-git-send-email-tj@kernel.org>
 <20110105163542.GA19474@redhat.com>
 <20110109220504.GA25707@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109220504.GA25707@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Jan 2011 23:05:04 +0100, Tejun Heo wrote:
> I think it would be a good idea to document the defined and probably
> more importantly undefined aspects of the ptrace behavior somewhere
> along with rational and implementation peculiarities.  Probably we
> should create a file under Documentation and also make sure the ptrace
> man page is kept synchronized with and point to it.

I tried so some years ago with:
	http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/PTRACE?cvsroot=systemtap

but it describes more just basics, still IIRC surprising to me that time.


Regards,
Jan
