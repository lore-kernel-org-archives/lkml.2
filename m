Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0IOT1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:27:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44040 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab0IOT1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:27:06 -0400
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com
In-Reply-To: <m1d3se7t0h.fsf@fess.ebiederm.org>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	 <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100915135016.C9F1.A69D9226@jp.fujitsu.com>
	 <1284531262.27089.15725.camel@nimitz>  <m1d3se7t0h.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 15 Sep 2010 12:27:01 -0700
Message-ID: <1284578821.27089.17409.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 11:37 -0700, Eric W. Biederman wrote:
> > I'm worried that there are users out there experiencing real problems
> > that aren't reporting it because "workarounds" like this just paper over
> > the issue.
> 
> For what it is worth.  I had a friend ask me about a system that had 50%
> of it's memory consumed by slab caches.  20GB out of 40GB.  The kernel
> was suse? 2.6.27 so it's old, but if you are curious.
> /proc/sys/vm/drop_caches does nothing in that case. 

Was it the reclaimable caches doing it, though?  The other really common
cause is kmalloc() leaks.

-- Dave

