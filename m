Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2GZOPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:15:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43031 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235Ab2GZOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:15:31 -0400
Message-ID: <1343312131.11398.23.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Update alignment check
From: Joe Perches <joe@perches.com>
To: Paul Walmsley <paul@booyaka.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jul 2012 07:15:31 -0700
In-Reply-To: <alpine.DEB.2.00.1207260306590.30049@utopia.booyaka.com>
References: <1339613458.28729.5.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207260306590.30049@utopia.booyaka.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 03:08 -0600, Paul Walmsley wrote:
> On Wed, 13 Jun 2012, Joe Perches wrote:
> > Parenthesis alignment doesn't correctly check an existing line
> > after an inserted or modified line with an open parenthesis.
[]
> This fixes some bogus checkpatch warnings here.  Andy, any chance this 
> patch can make it in for 3.6-rc?

That's pretty likely.

It's been in Andrew Morton's -mm and -next for awhile.


