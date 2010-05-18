Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0ERPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:21:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0ERPVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:21:09 -0400
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
 update_cpu_load (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
	 <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
	 <1274117717.1674.1539.camel@laptop>
	 <AANLkTik4EvvSwz9rD3zemuaSN3FMAIqsncZ5AKYOdaEn@mail.gmail.com>
	 <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 17:20:43 +0200
Message-ID: <1274196043.5605.8161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 18:14 -0700, Venkatesh Pallipadi wrote:
> Does this look better?

Yes, although whitespace challenged, but I fixed it up.

Thanks!
