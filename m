Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2BCQGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:06:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60763 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2BCQGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:06:49 -0500
Date: Fri, 3 Feb 2012 17:06:37 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Geunsik Lim <geunsik.lim@gmail.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Handling of unused variable 'do-numainfo on compilation
 time
Message-ID: <20120203160637.GB1690@cmpxchg.org>
References: <1328258627-2241-1-git-send-email-geunsik.lim@gmail.com>
 <20120203133950.GA1690@cmpxchg.org>
 <20120203145304.GA18335@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203145304.GA18335@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 03:53:04PM +0100, Michal Hocko wrote:
> On Fri 03-02-12 14:39:50, Johannes Weiner wrote:
> > Michal, this keeps coming up, please decide between the proposed
> > solutions ;-)
> 
> Hmm, I thought we already sorted this out https://lkml.org/lkml/2012/1/26/25 ?

Hah.  Sorry, I missed that.
