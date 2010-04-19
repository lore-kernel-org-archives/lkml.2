Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0DSW1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:27:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:48049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0DSW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:27:44 -0400
Message-ID: <4BCCD8BD.1020307@kernel.org>
Date: Tue, 20 Apr 2010 07:27:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>  <4BC65237.5080408@kernel.org>  <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>  <4BC6BE78.1030503@kernel.org>  <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>  <4BC6CB30.7030308@kernel.org>  <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>  <4BC6E581.1000604@kernel.org>  <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>  <4BC6FBC8.9090204@kernel.org>  <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>  <alpine.DEB.2.00.1004161105120.7710@router.home> <1271606079.2100.159.camel@barrios-desktop> <alpine.DEB.2.00.1004191235160.9855@router.home>
In-Reply-To: <alpine.DEB.2.00.1004191235160.9855@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Apr 2010 22:27:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 04/20/2010 02:38 AM, Christoph Lameter wrote:
> alloc_pages_exact_node results in more confusion because it does suggest
> that fallback to other nodes is not allowed.

I can't see why alloc_pages_exact_node() exists at all.  It's in the
mainline and if you look at the difference between alloc_pages_node()
and alloc_pages_exact_node(), it's almost silly.  :-(

-- 
tejun
