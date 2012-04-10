Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2DJJTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:19:17 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47099 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2DJJTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:19:16 -0400
Message-ID: <1334049554.2178.1.camel@shrek.rexursive.com>
Subject: Re: [PATCH v9]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: Per Olofsson <pelle@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 19:19:14 +1000
In-Reply-To: <4F83F202.2080600@debian.org>
References: <1334026047.2103.23.camel@shrek.rexursive.com>
	 <4F83F202.2080600@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 10:40 +0200, Per Olofsson wrote:
> Nitpick: it should be faster to calculate "nr_free_pages() -
> nr_free_highpages()", at least on systems without high pages. But
> perhaps it does not matter. 

Actually, nr_free_highpages() does a loop very similar to the one in the
patch. So, you would then have that and nr_free_pages() invocation.
That's why I went with just the loop.

Make sense?

-- 
Bojan

