Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab0HaBHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:07:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37720 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab0HaBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:07:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@kernel.dk,
        hch@lst.de, axboe@kernel.dk
In-Reply-To: <AANLkTimLwv04pvuz_AtSK3ASr-epD0PeA-vOCigFH8+0@mail.gmail.com>
References: <20100830092446.524B.A69D9226@jp.fujitsu.com> <AANLkTimLwv04pvuz_AtSK3ASr-epD0PeA-vOCigFH8+0@mail.gmail.com>
Message-Id: <20100831095932.87CD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 10:07:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Aug 29, 2010 at 5:28 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > afaict, you and wu agreed /debug/bdi/default/stats is enough good.
> > why do you change your mention?
> 
> I commented on this in the 0/4 email of the bug. I think these belong
> in /proc/vmstat but I saw they exist in /debug/bdi/default/stats. I
> figure they will probably not be accepted but I thought it was worth
> attaching for consideration of upgrading from debugfs to /proc.

For reviewers view, we are reviewing your patch to merge immediately if all issue are fixed.
Then, I'm unhappy if you don't drop merge blocker item even though you merely want asking.
At least, you can make separate thread, no?

Of cource, wen other user also want to expose via /proc interface, we are resume
this discusstion gradly.



