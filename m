Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1GVOVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:21:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1GVOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:21:49 -0400
Date: Fri, 22 Jul 2011 16:21:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: rcu: Convert trivial uses of call_rcu() to kfree_rcu()
In-Reply-To: <20110711144643.GA4076@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1107221621010.7300@pobox.suse.cz>
References: <20110711144643.GA4076@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Paul E. McKenney wrote:

> Hello, Jiri!
> 
> Does the patch below qualify as trivial?  If so, please feel free to
> take it off my hands.  ;-)

Hi Paul!

normally that would qualify, yes. But I can see that it's already in 
linux-next, so someone beat me picking it up (well, wasn't persumably too 
hard in this case).

Thanks,

-- 
Jiri Kosina
SUSE Labs
