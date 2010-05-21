Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0EUQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:25:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47634 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873Ab0EUQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:25:26 -0400
X-Sasl-enc: NgZ6QMyi+3Xi0Bi6CVf9PiSWqKNH3ARqdIlQdicSVylY 1274459115
Date: Fri, 21 May 2010 13:25:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at
 first
Message-ID: <20100521162512.GB7595@khazad-dum.debian.net>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com>
 <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
 <20100521103935.1E56.A69D9226@jp.fujitsu.com>
 <alpine.DEB.1.00.1005201859260.23122@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.1005201859260.23122@tigran.mtv.corp.google.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Hugh Dickins wrote:
> If you really want to test some workload on 2.6.28 to see if it too
> works better with your fix, I won't stop you - but I'd much prefer
> you to be applying your mind to 2.6.35 and 2.6.36!

And sending it to -stable (after merged in mainline) if it should be on
2.6.32/33/34, please.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
