Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1KUIMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:12:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab1KUIMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:12:23 -0500
Date: Mon, 21 Nov 2011 09:12:11 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: release pages in the error path of hugetlb_cow()
Message-ID: <20111121081152.GA1771@redhat.com>
References: <CAJd=RBC5Q48r0sYeqF9bucaBJPv3LR4UTAannUZ8KXxoXY_Qcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBC5Q48r0sYeqF9bucaBJPv3LR4UTAannUZ8KXxoXY_Qcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 09:01:20PM +0800, Hillf Danton wrote:
> If fail to prepare anon_vma, {new, old}_page should be released, or they will
> escape the track and/or control of memory management.
> 
> Thanks
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>
