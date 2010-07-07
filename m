Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0GGRBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:01:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0GGRBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:01:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-system-of-record;
	b=YMyuO5wWVtgUgbW40we4A4icmYb2pAg3heHddY66U9rZIIOb1f7so0xKIXlUBKBKt
	0Vr8PYoN2YY3HFDwjRzPQ==
Subject: Re: [patch 29/52] fs: icache lock i_count
From: Frank Mayhar <fmayhar@google.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Nick Piggin <npiggin@suse.de>, Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <48F48148-9909-47D0-A850-04B22403C006@mit.edu>
References: <20100624030212.676457061@suse.de>
	 <20100624030730.245992858@suse.de> <20100630072702.GF24712@dastard>
	 <20100630120502.GB21358@laptop>
	 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
	 <20100703034123.GE11732@laptop>
	 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
	 <20100703050652.GF11732@laptop> <20100705224106.GZ24712@dastard>
	 <20100706043439.GH11732@laptop>
	 <48F48148-9909-47D0-A850-04B22403C006@mit.edu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 07 Jul 2010 10:00:15 -0700
Message-Id: <1278522015.28816.6.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 06:38 -0400, Theodore Tso wrote:
> A lot of the text in this mail thread, including your discussion of the new
> locking hierarchy, and why things are the way they are, would be good
> fodder for a new documentation file.   And if you don't want to rename
> i_lock, because no better name can be found, we should at least
> document that starting as of 2.6.35/36 the meaning of i_lock changed.

Actually I like the idea of renaming i_lock.  It adds a bit of code
churn but renaming it to more clearly reflect its function makes sense
to me and might catch uses of it that might have been missed earlier.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

