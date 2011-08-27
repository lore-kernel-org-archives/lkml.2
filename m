Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1H0N6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:58:15 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41908 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1H0N6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:58:14 -0400
Date: Sat, 27 Aug 2011 15:58:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/8] cgroups: Add previous cgroup in
 can_attach_task/attach_task callbacks
Message-ID: <20110827135808.GI3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-4-git-send-email-fweisbec@gmail.com>
 <4E4B2A23.70105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B2A23.70105@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:40:35AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > This is to prepare the integration of a new max number of proc
> > cgroup subsystem. We'll need to release some resources from the
> > previous cgroup.
> > 
> 
> Documentation/cgroups/cgroups.txt needs update accordingly.

Yup, will update.

Thanks.
