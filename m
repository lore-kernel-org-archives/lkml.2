Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0DOLkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:40:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0DOLke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:40:34 -0400
Message-ID: <4BC6FBC8.9090204@kernel.org>
Date: Thu, 15 Apr 2010 20:43:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>	 <4BC6BE78.1030503@kernel.org>	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>	 <4BC6CB30.7030308@kernel.org>	 <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>	 <4BC6E581.1000604@kernel.org> <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
In-Reply-To: <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 11:39:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/15/2010 07:21 PM, Minchan Kim wrote:
> kill alloc_pages_exact_node?
> Sorry but I can't understand your point.
> I don't want to kill user of alloc_pages_exact_node.
> That's opposite.
> I want to kill user of alloc_pages_node and change it with
> alloc_pages_any_node or alloc_pages_exact_node. :)

I see, so...

 alloc_pages()		-> alloc_pages_any_node()
 alloc_pages_node()	-> alloc_pages_exact_node()

right?  It just seems strange to me and different from usual naming
convention - ie. something which doesn't care about nodes usually
doesn't carry _node postfix.  Anyways, no big deal, those names just
felt a bit strange to me.

Thanks.

-- 
tejun
