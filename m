Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0HYGiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:38:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201Ab0HYGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:38:10 -0400
Date: Tue, 24 Aug 2010 23:41:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] avoiding the same resource to be inserted
Message-Id: <20100824234132.a0f1cec3.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikSPB+8R4E7rsoVS2GN9ysROAPzKsLHqgMyP_yM@mail.gmail.com>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
	<20100824164622.a3b2c1ed.akpm@linux-foundation.org>
	<AANLkTikSPB+8R4E7rsoVS2GN9ysROAPzKsLHqgMyP_yM@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 13:03:55 +0800 Huang Shijie <shijie8@gmail.com> wrote:

> On Wed, Aug 25, 2010 at 7:46 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> I think WARN_ON() is not power enough. If the CONFIG_BUG is not
> defined, the warning message may not be printed. So I think using a
> directly printk() here is better.

No, WARN_ON() is good.  It gives us a backtrace and identifies the
buggy code.  Only maniacs turn off CONFIG_BUG.
