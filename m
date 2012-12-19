Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2LSAmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:42:11 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:46902 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2LSAmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:42:07 -0500
Date: Tue, 18 Dec 2012 16:42:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Doug Anderson <dianders@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
        Tejun Heo <tj@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] block: Avoid divide by 0 when max_discard_sectors is 0
In-Reply-To: <1355876729-25627-1-git-send-email-dianders@chromium.org>
Message-ID: <alpine.DEB.2.00.1212181641050.3932@chino.kir.corp.google.com>
References: <1355876729-25627-1-git-send-email-dianders@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Doug Anderson wrote:

> The recent commit "block: discard granularity might not be power of 2"
> introduced a divide by 0 in the kernel.  Previously the code didn't
> try to divide by discard_granularity when max_discard_sectors was 0.
> 
> Fix the code to only do the division if max_discard_sectors is
> specified.
> 

Could you try Linus' patch at 
http://marc.info/?l=linux-kernel&m=135584941732572 and give your Tested-by 
if it solves your issue?

Thanks.
