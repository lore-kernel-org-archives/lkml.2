Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2DJJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:27:16 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:41329 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2DJJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:27:15 -0400
Message-ID: <1334050034.2178.5.camel@shrek.rexursive.com>
Subject: Re: [PATCH v9]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: Per Olofsson <pelle@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 19:27:14 +1000
In-Reply-To: <4F83FBD6.6030104@debian.org>
References: <1334026047.2103.23.camel@shrek.rexursive.com>
	  <4F83F202.2080600@debian.org>
	 <1334049554.2178.1.camel@shrek.rexursive.com> <4F83FBD6.6030104@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 11:22 +0200, Per Olofsson wrote:
> If you don't have any high pages (e.g. x86_64), then
> nr_free_highpages() is defined to be 0 and is optimized away
> completely.

Yeah, we could do that in the patch too.

> Still, it seems you are not calculating free pages that often anymore
> so it should not matter much.

True. We call this a couple of orders of magnitude less times, so it
won't have noticeable affect on speed either way.

-- 
Bojan

