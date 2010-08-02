Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0HBIqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:46:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36358 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0HBIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:46:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux 2.6.35
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <npiggin@suse.de>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100802082428.GA23135@infradead.org>
References: <20100802075537.GC7841@amd> <20100802082428.GA23135@infradead.org>
Message-Id: <20100802173753.4F98.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  2 Aug 2010 17:46:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The per-zone shrinkers are another thing that's not directly related,
> I think they need a lot more discussion with the VM folks, and
> integrating with Dave's work in that area.

per-zone shrinkers don't cause so much impact to VM design except zone
reclaim feature. So, if FS folks think it's ok, I'm not against this at all.

btw, however, I haven't review such patch series in the detail yet. so
perhaps I might post some bug fix later.



