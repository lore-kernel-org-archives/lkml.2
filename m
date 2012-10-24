Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164Ab2JXTOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:14:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35947 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161129Ab2JXTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:14:34 -0400
Date: Wed, 24 Oct 2012 12:14:27 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] workqueue: remove unused argument of
 wq_worker_waking_up()
Message-ID: <20121024191427.GF12182@atj.dyndns.org>
References: <1350750607-2051-1-git-send-email-js1304@gmail.com>
 <1350750607-2051-4-git-send-email-js1304@gmail.com>
 <20121020225738.GB11442@htj.dyndns.org>
 <CAAmzW4OsXsDuMew7OvKOxktSxXe7C4_DuPQfvDLUCp7D0DSDoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4OsXsDuMew7OvKOxktSxXe7C4_DuPQfvDLUCp7D0DSDoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:44:49AM +0900, JoonSoo Kim wrote:
> >         if (!(worker->flags & WORKER_NOT_RUNNING)) {
> >                 WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
> >                 atomic_inc(get_pool_nr_running(worker->pool));
> >         }
> >
> 
> I have no objection to do this for now.

Care to cook up a patch?

Thanks.

--
tejun

