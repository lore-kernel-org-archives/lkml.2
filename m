Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0DRIbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 04:31:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab0DRIbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 04:31:36 -0400
Message-ID: <4BCA6B8E.9000408@kernel.org>
Date: Sun, 18 Apr 2010 11:16:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>,
       Hansjoerg Lipp <hjlipp@web.de>, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gigaset: include cleanup cleanup
References: <20100416220858.A19F540123@xenon.ts.pxnet.com>
In-Reply-To: <20100416220858.A19F540123@xenon.ts.pxnet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 18 Apr 2010 08:31:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/17/2010 07:08 AM, Tilman Schmidt wrote:
> Commit 5a0e3ad causes slab.h to be included twice in many of the
> Gigaset driver's source files, first via the common include file
> gigaset.h and then a second time directly. Drop the spares, and
> use the opportunity to clean up a few more similar cases.
> 
> Impact: cleanup, no functional change
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks for the clean up.

> Seeing that the "include cleanup" patch triggering this was accepted
> after the merge window, I have hopes this one will be accepted, too.

Hmm... through which tree should this go through?  I can route it
through percpu but maybe taking the usual isdn patch path would be
better?

Thanks.

-- 
tejun
