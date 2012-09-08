Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2IHRcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:32:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:32:38 -0400
Date: Sat, 8 Sep 2012 10:32:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120908173234.GB10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120906200802.GI29092@google.com>
 <504965AA.6090107@cn.fujitsu.com>
 <20120907192939.GF9426@google.com>
 <20120907202249.GH9426@google.com>
 <20120907203414.GI9426@google.com>
 <20120907230556.GJ9426@google.com>
 <20120907230746.GK9426@google.com>
 <20120907234158.GL9426@google.com>
 <CACvQF51CEjqx_5pftzf6BwxCtyV8zGsVNBKjKBtt-L_iSxr4iQ@mail.gmail.com>
 <20120908172950.GA10788@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908172950.GA10788@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 10:29:50AM -0700, Tejun Heo wrote:
> > hotplug code can't iterate manager.  not rebind_work() nor UNBOUND for manager.
> 
> Ah, right.  It isn't either on idle or busy list.  Maybe have
> pool->manager pointer?

Ooh, this is what you did with the new patchset, right?

-- 
tejun
