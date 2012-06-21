Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2FUNEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:04:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43177 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554Ab2FUNEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:04:36 -0400
Date: Thu, 21 Jun 2012 14:04:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        gregkh@linuxfoundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        tim.bird@am.sony.com, frank.rowand@am.sony.com,
        takuzo.ohara@ap.sony.com, kan.iibuchi@jp.sony.com,
        aaditya.kumar@ap.sony.com
Subject: Re: [PATCH] mm: offlining memory may block forever
Message-ID: <20120621130432.GB3953@csn.ul.ie>
References: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 09:53:31PM +0530, Aaditya Kumar wrote:
> Offlining memory may block forever, waiting for kswapd() to wake up because
> kswapd() does not check the event kthread->should_stop before sleeping.
> 

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
