Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0E0Nqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:46:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52941 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab0E0Nqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I+WoWscc3AvYUDJnrb4bwSUSE+hU+/xn/EaOFMZ0MYfrufrzm5bie4rSSpjuXYan53
         cX3UwIUMBdvJ1GmL7NpenXEHfCoCu+l3LLVXh4D5ks5z5yTgY1xk+JtaSK0qbRXzRbKL
         DyxByVaNoKFkrvDPAvTfWKfO2O4mjp7Ff9cHU=
Date: Thu, 27 May 2010 22:46:31 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 2/5] change direct call of spin_lock(anon_vma->lock) to
 inline function
Message-ID: <20100527134631.GB2112@barrios-desktop>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
 <20100526153926.1272945b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526153926.1272945b@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:39:26PM -0400, Rik van Riel wrote:
> Subject: change direct call of spin_lock(anon_vma->lock) to inline function
> 
> Subsitute a direct call of spin_lock(anon_vma->lock) with
> an inline function doing exactly the same.
> 
> This makes it easier to do the substitution to the root
> anon_vma lock in a following patch.
> 
> We will deal with the handful of special locks (nested,
> dec_and_lock, etc) separately.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
