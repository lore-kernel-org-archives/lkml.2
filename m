Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1JAP3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:29:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1JAP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:29:36 -0400
Date: Sat, 1 Oct 2011 17:29:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 11/12] cgroups: Allow subsystems to cancel a fork
Message-ID: <20111001152927.GD3391@somewhere>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-12-git-send-email-fweisbec@gmail.com>
 <20110915140941.6b278dfb.akpm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915140941.6b278dfb.akpm@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:09:41PM -0700, Andrew Morton wrote:
> On Tue,  6 Sep 2011 02:13:05 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Let the subsystem's fork callback return an error value so
> > that they can cancel a fork. This is going to be used by
> > the task counter subsystem to implement the limit.
> 
> This breaks the build quite gruesomely with CONFIG_CGROUPS=n.  I looked
> at doing a quick fix but that would just have piled ugly on ugly.
> 

Sorry about that. I'm fixing the whole so that it builds with or
without cgroups. 

I'm also improving the documentation and changelog along the way.

Thanks.
