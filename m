Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1E0Wic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:38:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53168
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826Ab1E0Wib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:38:31 -0400
X-Greylist: delayed 8495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 18:38:31 EDT
Subject: Re: [RFC][PATCH v3 7/10] workqueue: add WQ_IDLEPRI
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
In-Reply-To: <20110526093808.GE9715@htj.dyndns.org>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	 <20110526143024.7f66e797.kamezawa.hiroyu@jp.fujitsu.com>
	 <20110526093808.GE9715@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 22:20:13 +0200
Message-ID: <1306527613.2497.476.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 11:38 +0200, Tejun Heo wrote:
> 
> We can add a mechanism to manage work item scheduler priority to
> workqueue if necessary tho, I think.  But that would be per-workqueue
> attribute which is applied during execution, not something per-gcwq.
> 
Only if we then also make PI possible ;-)

