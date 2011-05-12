Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab1ELPzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:55:46 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33585 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab1ELPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:55:45 -0400
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: Pekka Enberg <penberg@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <1305214993.2575.50.camel@mulgrave.site>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 12 May 2011 18:55:42 +0300
Message-ID: <1305215742.27848.40.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 10:43 -0500, James Bottomley wrote:
> However, since you admit even you see problems, let's concentrate on
> fixing them rather than recriminations?

Yes, please. So does dropping max_order to 1 help?
PAGE_ALLOC_COSTLY_ORDER is set to 3 in 2.6.39-rc7.

			Pekka

