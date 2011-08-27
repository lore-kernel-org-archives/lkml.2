Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1H0N7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:59:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1H0N7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:59:02 -0400
Date: Sat, 27 Aug 2011 15:58:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/8] cgroups: New cancel_attach_task subsystem callback
Message-ID: <20110827135856.GJ3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-5-git-send-email-fweisbec@gmail.com>
 <4E4B2A33.6060909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B2A33.6060909@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:40:51AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > To cancel a process attachment on a subsystem, we only call the
> > cancel_attach() callback once on the leader but we have no
> > way to cancel the attachment individually for each member of
> > the process group.
> > 
> > This is going to be needed for the max number of tasks susbystem
> > that is coming.
> > 
> > To prepare for this integration, call a new cancel_attach_task()
> > callback on each task of the group until we reach the member that
> > failed to attach.
> > 
> 
> Document this new callback in Documentation/cgroups/cgroups.txt

I will.

Thanks.
