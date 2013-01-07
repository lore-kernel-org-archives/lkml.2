Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3AGOi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:38:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3AGOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:38:57 -0500
Date: Mon, 7 Jan 2013 14:38:54 +0000
From: Mel Gorman <mgorman@suse.de>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        hughd@google.com, Michel Lespinasse <walken@google.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: thp: Acquire the anon_vma rwsem for lock during split
Message-ID: <20130107143854.GH3885@suse.de>
References: <1621091901.34838094.1356409676820.JavaMail.root@redhat.com>
 <535932623.34838584.1356410331076.JavaMail.root@redhat.com>
 <20130103175737.GA3885@suse.de>
 <20130104140815.GA26005@suse.de>
 <50E7BF4D.4040204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50E7BF4D.4040204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 01:51:09PM +0800, Zhouping Liu wrote:
> On 01/04/2013 10:08 PM, Mel Gorman wrote:
> >Zhouping, please test this patch.
> 
> Tested it, the issue is gone with following patch.
> 
> Tested-by: Zhouping Liu <zliu@redhat.com>
> 

Super. Thanks very much for reporting and testing this quickly.

-- 
Mel Gorman
SUSE Labs
