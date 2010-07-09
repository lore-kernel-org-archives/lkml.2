Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0GIIgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:36:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62117 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0GIIgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XiqEGTn26yVFeLNsrImu57Dgq+jPcXG9eKdVqmgRqBFTkNjdJLQg9bAj9ebzl3v0F5
         yGvPb0OoiiP90GGMARZ5m9lI7p9Exfv1/5P8+5fLFhJSDnSbRE3EiUfmgeocdWuUaEC6
         aklzDCjAIhHvcPum0QoK4B5CxAOC+IQUuE8Cw=
MIME-Version: 1.0
In-Reply-To: <20100708163934.CD37.A69D9226@jp.fujitsu.com>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
	<20100708163934.CD37.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Jul 2010 17:36:07 +0900
Message-ID: <AANLkTinwZfaQiTJhP8RcGhlSS-ynEXtbpzorrIZrNyIH@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages, 
	not page order
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 4:40 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Fix simple argument error. Usually 'order' is very small value than
> lru_pages. then it can makes unnecessary icache dropping.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

With your test result, This patch makes sense to me.
Please, include your test result in description.

-- 
Kind regards,
Minchan Kim
