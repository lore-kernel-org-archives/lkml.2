Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1HPVu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:50:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43709 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab1HPVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:50:25 -0400
Subject: Re: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110816195121.GG2803@mtj.dyndns.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-42-git-send-email-matt@console-pimps.org>
	 <20110816180644.GJ29190@redhat.com> <20110816194427.GA6602@redhat.com>
	 <20110816194450.GB6602@redhat.com>  <20110816195121.GG2803@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 22:50:22 +0100
Message-ID: <1313531422.3436.218.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 21:51 +0200, Tejun Heo wrote:
> 
> I agree with the patchset but given that daemonize() isn't all that
> popular and you already posted most (or was it all?) conversions,
> wouldn't it be better to do this in a single patchset?  ie. Convert
> all daemonize() users, kill daemonize(), and drop the hack from
> allow_signal().

But because daemonize() is exported by the kernel should it go through
the Documentation/feature-removal-schedule.txt procedure? And if so, can
the allow_signal() patch still go in before daemonize() is removed?

-- 
Matt Fleming, Intel Open Source Technology Center

