Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab0HFATL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:19:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60820 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab0HFATI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:19:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and  pages_entered_writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
In-Reply-To: <AANLkTimD4jkkPpnhQhR+OF=6=dWV2dJj4M_DGfAmHgRQ@mail.gmail.com>
References: <20100806084928.31DE.A69D9226@jp.fujitsu.com> <AANLkTimD4jkkPpnhQhR+OF=6=dWV2dJj4M_DGfAmHgRQ@mail.gmail.com>
Message-Id: <20100806091548.31ED.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  6 Aug 2010 09:18:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Aug 5, 2010 at 4:56 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > /proc/vmstat already have both.
> >
> > cat /proc/vmstat |grep nr_dirty
> > cat /proc/vmstat |grep nr_writeback
> >
> > Also, /sys/devices/system/node/node0/meminfo show per-node stat.
> >
> > Perhaps, I'm missing your point.
> 
> These only show the number of dirty pages present in the system at the
> point they are queried.
> The counter I am trying to add are increasing over time. They allow
> developers to see rates of pages being dirtied and entering writeback.
> Which is very helpful.

Usually administrators get the data two times and subtract them. Isn't it sufficient?


