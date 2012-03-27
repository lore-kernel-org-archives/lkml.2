Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab2C0Wx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:53:59 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36621 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2C0Wx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:53:58 -0400
Message-ID: <1332888836.2040.20.camel@shrek.rexursive.com>
Subject: Re: [PATCH v5]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Wed, 28 Mar 2012 09:53:56 +1100
In-Reply-To: <201203280054.01695.rjw@sisk.pl>
References: <1332887486.2040.10.camel@shrek.rexursive.com>
	 <201203280047.33501.rjw@sisk.pl>
	 <1332888231.2040.14.camel@shrek.rexursive.com>
	 <201203280054.01695.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 00:54 +0200, Rafael J. Wysocki wrote:
> That's better, but what's wrong with a static inline, actually?

Nothing, if that is what is required to get the patch accepted. :-)

I just thought that given that nr_free_pages() is already a macro with
no side effects, it would make sense for reqd_free_pages() or
REQD_FREE_PAGES to remain a macro.

But, if you insist on static inline, I'll do static inline. Let me know.

-- 
Bojan

