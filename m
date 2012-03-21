Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2CUTgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:36:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2CUTgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:36:10 -0400
Message-ID: <1332358552.18960.501.camel@twins>
Subject: RE: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael J. Wang" <mjwang@broadcom.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date: Wed, 21 Mar 2012 20:35:52 +0100
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC85433@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
	 <20120321014050.GA19766@zhy>
	 <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
	 <20120321021229.GB19766@zhy>
	 <2EF88150C0EF2C43A218742ED384C1BC0FC8438B@IRVEXCHMB08.corp.ad.broadcom.com>
	 <1332320819.18960.468.camel@twins>
	 <2EF88150C0EF2C43A218742ED384C1BC0FC85433@IRVEXCHMB08.corp.ad.broadcom.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 18:33 +0000, Michael J. Wang wrote:
> 
> OK.  Thanks.  I was afraid the details were too verbose when the fix
> was obvious to the experts.  Anyways, I now know the format you
> are expecting, so I will do better next time. 

Since you took the trouble to write it, I thought it worth the trouble
to include.

Very often Changelogs are way too spartan (my own included), I can't
recall the amount of times I've kicked myself for leaving out some - at
the time - obvious details.

So I prefer people to go overboard a bit and err on the side of too much
information :-)
