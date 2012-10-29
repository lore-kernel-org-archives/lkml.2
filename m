Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2J2POy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:14:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:52222 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2J2POw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:14:52 -0400
Date: Mon, 29 Oct 2012 08:14:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] workqueue: cancel_delayed_work() should return %NULL if
 work item is idle
Message-ID: <20121029151447.GJ5171@htj.dyndns.org>
References: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
 <20121018233928.GY13370@google.com>
 <20121029094707.GC9314@aemeltch-MOBL1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029094707.GC9314@aemeltch-MOBL1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:47:13AM +0200, Andrei Emeltchenko wrote:
> Gustavo, could you apply the patch below to bluetooth-next tree, otherwise
> it is deadly broken.

Already applied to mainline (c0158ca64da5732dfb86a3f28944e9626776692f).

If pulling mainline is too much, please feel free to pull

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7-fixes

Sorry about the trouble.

-- 
tejun
