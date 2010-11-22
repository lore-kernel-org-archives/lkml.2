Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0KVH2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:28:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50098 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0KVH2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:28:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Nov 2010 08:26:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101122082657.43a2ad91@stein>
In-Reply-To: <201011221141.19250.br1@einfach.org>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	<201011191749.31974.br1@einfach.org>
	<20101119150451.1c0d273f@stein>
	<201011221141.19250.br1@einfach.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22 Bruno Randolf wrote:
> On Fri November 19 2010 23:04:51 Stefan Richter wrote:
> > You only showed that CPU utilization is not so high that an effect on
> > network throughput can be seen.  You did not measure what the increase
> > in CPU utilization actually was. :-)
> 
> True. That's exactly the point: "CPU utilization is not so high that an effect 
> on network throughput can be seen", which was what people were worrying about.

No, people worried about CPU utilization that can be reduced.

> So IMHO: No problem! :) But of course it makes sense to optimize and I'll try 
> to do that in subsequent patches.

Good.
-- 
Stefan Richter
-=====-==-=- =-== =-==-
http://arcgraph.de/sr/
