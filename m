Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2JSBAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:00:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47053 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757089Ab2JSBAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:00:32 -0400
Message-ID: <1350608431.22385.18.camel@joe-AO722>
Subject: Re: [PATCH 00/23] printk: refactoring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 18:00:31 -0700
In-Reply-To: <20121018161601.c47c50c8.akpm@linux-foundation.org>
References: <cover.1350449851.git.joe@perches.com>
	 <20121018161601.c47c50c8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:16 -0700, Andrew Morton wrote:
> It wouldn't hurt to describe the design here a bit.  How was the code
> partitioned and what is the role of each file?
> 
> That's reasonably obvious from the names, but some might wonder about
> the difference between printk_log and printk_syslog and how that
> division was decided upon.

printk_log is Kay's record oriented logging stuff,
printk_syslog is syslog(2),
the rest is I hope trivially obvious.


