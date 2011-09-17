Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1IQSeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 14:34:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35707 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1IQSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 14:34:05 -0400
Date: Sat, 17 Sep 2011 22:33:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
Message-ID: <20110917183358.GB2783@moon>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-5-git-send-email-glommer@parallels.com>
 <20110917181132.GC1658@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110917181132.GC1658@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 09:11:32PM +0300, Kirill A. Shutemov wrote:
> On Wed, Sep 14, 2011 at 10:46:12PM -0300, Glauber Costa wrote:
> > +int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
> > +			 struct cgroup_subsys *ss)
> > +{
> > +	prot->enter_memory_pressure	= tcp_enter_memory_pressure;
> > +	prot->memory_allocated		= memory_allocated_tcp;
> > +	prot->prot_mem			= tcp_sysctl_mem;
> > +	prot->sockets_allocated		= sockets_allocated_tcp;
> > +	prot->memory_pressure		= memory_pressure_tcp;
> 
> No fancy formatting, please.
> 

What's wrong with having fancy formatting? It's indeed easier to read
when members are assigned this way. It's always up to maintainer to
choose what he prefers, but I see nothing wrong in such style (if only it
doesn't break the style of the whole file).

	Cyrill
