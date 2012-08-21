Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2HUHe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:34:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2HUHey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:34:54 -0400
Date: Tue, 21 Aug 2012 08:29:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Memory policy corruption fixes V2
Message-ID: <20120821072901.GD1657@suse.de>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1345480594-27032-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 05:36:29PM +0100, Mel Gorman wrote:
> This is a rebase with some small changes to Kosaki's "mempolicy memory
> corruption fixlet" series. I had expected that Kosaki would have revised
> the series by now but it's been waiting a long time.
> 
> Changelog since V1
> o Rebase to 3.6-rc2
> o Editted some of the changelogs
> o Converted sp->lock to sp->mutex to close a race in shared_policy_replace()
> o Reworked the refcount imbalance fix slightly
> o Do not call mpol_put in shmem_alloc_page.
> 
> I tested this with trinity with CONFIG_DEBUG_SLAB enabled and it passed. I
> did not test LTP such as Josh reported a problem with or with a database that
> used shared policies like Andi tested. The series is almost all Kosaki's
> work of course. If he has a revised series that simply got delayed in
> posting it should take precedence.

I meant to add Josh to the cc, adding him now.

-- 
Mel Gorman
SUSE Labs
