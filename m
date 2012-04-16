Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2DPV6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:58:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DPV6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:58:00 -0400
Date: Mon, 16 Apr 2012 14:57:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch v2] workqueue: change BUG_ON() to WARN_ON()
Message-ID: <20120416215755.GA12421@google.com>
References: <CAOS58YOSy-acB7Oara9ay1Zeznx0vCSB0Z23F+6KtEKZ56nXmQ@mail.gmail.com>
 <20120413190658.GA18505@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413190658.GA18505@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:06:58PM +0300, Dan Carpenter wrote:
> This BUG_ON() can be triggered if you call schedule_work() before
> calling INIT_WORK().  It is a bug definitely, but it's nicer to just
> print a stack trace and return.
> 
> Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to wq/for-3.5.  Thanks.

-- 
tejun
