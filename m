Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2DZToS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:44:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61614 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2DZToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:44:17 -0400
Subject: Re: [PATCH] slub: prevent validate_slab() error due to race
 condition
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Don Morris <don.morris@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F999FFB.3070408@hp.com>
References: <1335466658-29063-1-git-send-email-Waiman.Long@hp.com>
	 <1335467575.2775.61.camel@edumazet-glaptop>  <4F999FFB.3070408@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Apr 2012 21:44:11 +0200
Message-ID: <1335469451.2775.64.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 12:20 -0700, Don Morris wrote:

> Note that he sets n here, hence the if() block on 2458 can not
> be taken (!n fails) and the if(likely(!n)) is not taken for the
> same reason. As such, the code falls through to the returns for
> either the slab being empty (or not) where the node lock is
> released (2529 / 2543).

Ah yes, you're right, thanks for clarification.



