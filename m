Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0DPWiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:38:11 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:53789 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab0DPWiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:38:08 -0400
Date: Sat, 17 Apr 2010 00:37:58 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/10] vmscan: kill prev_priority completely
Message-ID: <20100416223758.GD20640@cmpxchg.org>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-2-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271352103-2280-2-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:34PM +0100, Mel Gorman wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Since 2.6.28 zone->prev_priority is unused. Then it can be removed
> safely. It reduce stack usage slightly.
> 
> Now I have to say that I'm sorry. 2 years ago, I thghout prev_priority
> can be integrate again, it's useful. but four (or more) times trying
> haven't got good performance number. thus I give up such approach.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
