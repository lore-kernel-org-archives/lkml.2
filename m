Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1DOIbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:31:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:54196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1DOIbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:31:16 -0400
Date: Fri, 15 Apr 2011 10:31:14 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in
 cpuset_mem_spread_node()
Message-ID: <20110415083113.GA11884@tiehlicka.suse.cz>
References: <20110415161831.12F8.A69D9226@jp.fujitsu.com>
 <20110415082051.GB8828@tiehlicka.suse.cz>
 <20110415172855.12FF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415172855.12FF.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-04-11 17:29:00, KOSAKI Motohiro wrote:
[...]
> > Change from v1:
> > - initialize cpuset_{mem,slab}_spread_rotor lazily
> 
> Yeah! This is much much better than mine. Thank you!
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thank you for the careful review.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
