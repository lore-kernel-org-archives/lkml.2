Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2GXC3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:29:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52983 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751321Ab2GXC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:29:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+XUvgUcYmXuk8fk0oGUUGgEHpPIpMqVl+39zmhnK
	NoUYKVMG0rxsDP
Message-ID: <1343096969.7412.21.camel@marge.simpson.net>
Subject: Re: [MMTests] Sysbench read-only on ext3
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jul 2012 04:29:29 +0200
In-Reply-To: <20120723211334.GA9222@suse.de>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	 <20120723211334.GA9222@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 22:13 +0100, Mel Gorman wrote:

> The backing database was postgres.

FWIW, that wouldn't have been my choice.  I don't know if it still does,
but it used to use userland spinlocks to achieve scalability.  Turning
your CPUs into space heaters to combat concurrency issues makes a pretty
flat graph, but probably doesn't test kernels as well as something that
did not do that.

-Mike


