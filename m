Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0ETHRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:17:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:37990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0ETHRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:17:14 -0400
Subject: Re: [PATCH] sched: fix updating sd->balance_interval in
 idle_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1274312730-3041-1-git-send-email-ncrao@google.com>
References: <1274312730-3041-1-git-send-email-ncrao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 09:16:49 +0200
Message-ID: <1274339809.5605.13119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 16:45 -0700, Nikhil Rao wrote:
> sd->balance_interval is updated incorrectly when SD_BALANCE_NEWIDLE is not set
> in sd->flags. This patch updates sd->balance_interval only when we balance the
> domain. 

I really need more than that.

Why is it wrong, what are the (measurable) effects of changing it and
how did it come to be this way.

I could of course go and try to reverse engineer your patch, but it
would be awesome if I didn't have to.
