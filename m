Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937233Ab0CPAVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:21:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35194 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab0CPAVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:21:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] mm: remove return value of putback_lru_pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1268658994.1889.8.camel@barrios-desktop>
References: <1268658994.1889.8.camel@barrios-desktop>
Message-Id: <20100316092041.4C34.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Mar 2010 09:21:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Now putback_lru_page never can fail.
> So it doesn't matter count of "the number of pages put back".
> 
> In addition, users of this functions don't use return value.
> 
> Let's remove unnecessary code.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




