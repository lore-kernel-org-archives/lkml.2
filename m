Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762Ab0HEX42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:56:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60030 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0HEX4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:56:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and  pages_entered_writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
In-Reply-To: <AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com>
References: <20100805132433.d1d7927b.akpm@linux-foundation.org> <AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com>
Message-Id: <20100806084928.31DE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  6 Aug 2010 08:56:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Aug 5, 2010 at 1:24 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed,  4 Aug 2010 17:43:24 -0700
> > Michael Rubin <mrubin@google.com> wrote:
> > Wait.  These counters appear in /proc/vmstat.  So why create standalone
> > /proc/sys/vm files as well?
> 
> I did not know they would show up in /proc/vmstat.
> 
> I thought it made sense to put them in /proc/sys/vm since the other
> writeback controls are there.
> but have no problems just adding them to /prov/vmstat if that makes more sense.

?

/proc/vmstat already have both.

cat /proc/vmstat |grep nr_dirty
cat /proc/vmstat |grep nr_writeback

Also, /sys/devices/system/node/node0/meminfo show per-node stat.

Perhaps, I'm missing your point.


