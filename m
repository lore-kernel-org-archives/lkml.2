Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1GGSav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:30:51 -0400
Received: from waste.org ([173.11.57.241]:47608 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1GGSas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:30:48 -0400
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, rientjes@google.com,
        linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1107071314320.21719@router.home>
References: <20110626193918.GA3339@joi.lan>
	 <alpine.DEB.2.00.1107072106560.6693@tiger>
	 <alpine.DEB.2.00.1107071314320.21719@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 13:30:44 -0500
Message-ID: <1310063444.3637.10.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 13:17 -0500, Christoph Lameter wrote:
> On Thu, 7 Jul 2011, Pekka Enberg wrote:
> 
> > Looks good to me. Christoph, David, ?
> 
> The reason debug code is there is because it is useless overhead typically
> not needed. There is no point in optimizing the code that is not run in
> production environments unless there are gross performance issues that
> make debugging difficult. A performance patch for debugging would have to
> cause significant performance improvements. This patch does not do that
> nor was there such an issue to be addressed in the first place.

Deja vu.

-- 
Mathematics is the supreme nostalgia of our time.


