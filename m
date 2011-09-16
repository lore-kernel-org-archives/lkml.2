Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1IPJWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:22:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:17800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1IPJW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,392,1312182000"; 
   d="scan'208";a="49483263"
Date: Fri, 16 Sep 2011 17:18:52 -0400
From: xingchao <xingchao.wang@intel.com>
To: Paul Turner <pjt@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
        "Shi, Alex" <alex.shi@intel.com>
Subject: Re: [PATCH] cfs: NULL pointer check
Message-ID: <20110916171852.17f75ce6@wang-bj-intel>
In-Reply-To: <4E72FDF1.3080608@google.com>
References: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
	<4E72FDF1.3080608@google.com>
Organization: INTEL
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 15:42:41 +0800
Paul Turner <pjt@google.com> wrote:

> On 09/16/11 10:48, Wang Xingchao wrote:
> > se maybe NULL if cfs_rq->rb_leftmost is NULL
> 
> nack, it had better not be; otherwise we've got a corrupt tree!
> 
> Also, this diff is against the previous -- please bundle dependent 
> patches as a series in the future.
> 
Got it.  :)
Paul, i'd send another patch to remove the NULL pointer check
in __pick_first/last_entity().

--xingchao
