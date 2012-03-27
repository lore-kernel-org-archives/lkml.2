Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2C0X3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:29:54 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:48341 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2C0X3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:29:53 -0400
Message-ID: <1332890991.2040.22.camel@shrek.rexursive.com>
Subject: Re: [PATCH v5]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Wed, 28 Mar 2012 10:29:51 +1100
In-Reply-To: <201203280118.59154.rjw@sisk.pl>
References: <1332887486.2040.10.camel@shrek.rexursive.com>
	 <201203280054.01695.rjw@sisk.pl>
	 <1332888836.2040.20.camel@shrek.rexursive.com>
	 <201203280118.59154.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 01:18 +0200, Rafael J. Wysocki wrote:
> Please do.

OK.

> You can even convert nr_free_pages() to a static inline while
> you're at it. :-)

Er, not straightforward, actually. I think the fact that there is a
comment like below actually has something to do with it:

/* Definition of global_page_state not available yet */

So, I think I'm going to leave that be.

-- 
Bojan

