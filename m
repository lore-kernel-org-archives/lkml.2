Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1FLJJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 05:09:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1FLJJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 05:09:23 -0400
Date: Sun, 12 Jun 2011 11:09:17 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: 3.0rc2 oops in mem_cgroup_from_task
Message-ID: <20110612090917.GA19493@tiehlicka.suse.cz>
References: <20110609212956.GA2319@redhat.com>
 <20110611081937.GB7042@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1106110839270.29336@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1106110839270.29336@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11-06-11 08:46:54, Hugh Dickins wrote:
> The discussion in https://lkml.org/lkml/2011/6/9/538
> has continued in https://lkml.org/lkml/2011/6/10/2

Thanks for the pointer, Hugh. I have missed that thread @kvack.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
