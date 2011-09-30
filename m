Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1I3Myx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:54:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1I3Myw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:54:52 -0400
Date: Fri, 30 Sep 2011 14:54:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.osdl.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/11] cgroups: Add a task counter subsystem
Message-ID: <20110930125441.GB19053@somewhere>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
 <1315869091-18933-10-git-send-email-fweisbec@gmail.com>
 <20110918202710.GE28057@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918202710.GE28057@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 11:27:10PM +0300, Kirill A. Shutemov wrote:
> On Tue, Sep 13, 2011 at 01:11:29AM +0200, Frederic Weisbecker wrote:
> > +static struct cftype files[] = {
> > +	{
> > +		.name		= "limit",
> > +		.read_u64	= task_counter_read_u64,
> > +		.write_u64	= task_counter_write_u64,
> > +		.private	= RES_LIMIT,
> > +	},
> > +
> > +	{
> > +		.name		= "usage",
> > +		.read_u64	= task_counter_read_u64,
> 
> It would be nice to implement .register_event/.unregister_event as well.

It adds several complications. I prefer to wait for someone requesting
that feature before doing it.
