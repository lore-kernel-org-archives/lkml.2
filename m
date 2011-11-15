Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1KODnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 22:43:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42397 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396Ab1KODnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 22:43:15 -0500
Message-ID: <1321328468.18124.2.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1321325960.13860.75.camel@yhuang-dev>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
	 <1321324217.8944.25.camel@Joe-Laptop>
	 <1321325960.13860.75.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 19:41:08 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 10:59 +0800, Huang Ying wrote:
> For multiple part in one line.  I think the better solution may be to
> assemble them in a line buffer before real output to console to avoid
> interleaving.  Do you think so?

Hard to say yes for sure.  Immediacy has some value.

There are some downsides to preassembly in memory
constrained systems.

On the other hand, most uses of pr_cont don't create
very long lines.

