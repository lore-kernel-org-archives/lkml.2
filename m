Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab1HaSMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 14:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab1HaSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 14:12:38 -0400
Date: Wed, 31 Aug 2011 20:08:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
	setting bug in freezer_change_state()
Message-ID: <20110831180858.GA10725@redhat.com>
References: <20110831102100.GA2828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831102100.GA2828@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31, Tejun Heo wrote:
>
> I'm in the process of moving and can only use a quite old laptop.  I
> tested compile but couldn't really do much else, so please proceed
> with caution.  Oleg, can you please ack the patches if you agree with
> the updated versions?

Everything looks fine. But I am already sleeping now ;)

Rafael, Tejun, I'll try to re-read 1-4 tomorrow. I do not expect I'll
find something interesting, just I am paranoid.

Looks like, 1/4 could have an additional note in the changelog, with
this patch we avoid the unnecessary try_to_freeze_cgroup() and this
looks like a win to me...

Oleg.

