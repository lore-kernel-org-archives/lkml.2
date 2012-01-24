Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2AXCAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:00:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42762 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755368Ab2AXCAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:00:47 -0500
Message-ID: <1327370429.20805.4.camel@joe2Laptop>
Subject: Re: [Xen-devel] [PATCH] include/checkpatch: Prefer __scanf to
 __attribute__((format(scanf, ...)
From: Joe Perches <joe@perches.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andy Whitcroft <apw@canonical.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Date: Mon, 23 Jan 2012 18:00:29 -0800
In-Reply-To: <20120124014717.GA24204@andromeda.dapyr.net>
References: <2cf7ddd75001233e79e928c4dcfae6768af5790c.1327103792.git.joe@perches.com>
	 <20120124014717.GA24204@andromeda.dapyr.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 21:47 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 20, 2012 at 04:01:12PM -0800, Joe Perches wrote:
> > It's equivalent to __printf, so prefer __scanf.
> So ... looking at this patch it just seems to macro-fy the
> __printf and __scanf attributes.

It's just for __scanf.  The __printf change is just
a neatening/spacing change.

> Is this required to make
> cleanpatch.pl work easier?

No.  It's a trivial symmetry patch added to
make fewer uses of __attribute__((format(...)
similar to the __printf commit from awhile ago.

commit b9075fa968a0a4347aef35e235e2995c0e57dddd

> And there is also some checkpatch.pl features. Should that part
> be in a seperate patch?

I think it's OK to do the whole thing at once.

