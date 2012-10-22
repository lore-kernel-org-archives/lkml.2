Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2JVSnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:43:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:58001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2JVSnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:43:41 -0400
Message-ID: <508593D4.20908@kernel.dk>
Date: Mon, 22 Oct 2012 20:43:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] blkcg: stop iteration early if root_rl is the only request
 list
References: <50750367.2070508@ce.jp.nec.com> <20121010155929.GA18733@redhat.com> <50762182.5090806@ce.jp.nec.com> <20121016232040.GH16166@google.com> <507DF58E.8060804@ce.jp.nec.com> <20121017134704.GB31663@redhat.com> <507F6FE2.3030303@ce.jp.nec.com> <20121018133149.GA18147@redhat.com> <20121018212053.GK13370@google.com> <50849E39.2040609@ce.jp.nec.com>
In-Reply-To: <50849E39.2040609@ce.jp.nec.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-22 03:15, Jun'ichi Nomura wrote:
> __blk_queue_next_rl() finds next request list based on blkg_list
> while skipping root_blkg in the list.
> OTOH, root_rl is special as it may exist even without root_blkg.
> 
> Though the later part of the function handles such a case correctly,
> exiting early is good for readability of the code.

Applied to for-linus, thanks.

-- 
Jens Axboe

