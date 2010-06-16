Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab0FPPKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:10:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57942 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0FPPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C1JfnNpFv7stBk5lFnJkPSVMfrFKJEIQvJMTAmk6wwb8p7b5RP6vGX/SkxLQozsxAl
         kzRFw6D5SXofDAfqgOIcV53vmGjqzNrNpsx8BAjoYZGX7oGywQF2hh2K0Vb8OY9SeopR
         V0/FQKb/AlnF4MfD/pGYrFPu4hf1wKBSwawgM=
Date: Thu, 17 Jun 2010 00:10:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/9] oom: make oom_unkillable_task() helper function
Message-ID: <20100616151012.GE9278@barrios-desktop>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
 <20100616203247.72E3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616203247.72E3.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:33:17PM +0900, KOSAKI Motohiro wrote:
> 
> Now, we have the same task check in three places. Unify it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

But please consider my previous comment.
If I am not wrong, we need change this patch, too.
-- 
Kind regards,
Minchan Kim
