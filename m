Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847Ab0COXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:53:18 -0400
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:43320 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965803Ab0COXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:53:17 -0400
Date: Mon, 15 Mar 2010 19:53:10 -0400 (EDT)
From: Ari Entlich <atrigent@ccs.neu.edu>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <2163366.511711268697190113.JavaMail.root@zimbra>
In-Reply-To: <455171.511691268697128244.JavaMail.root@zimbra>
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.178]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Greg KH" <greg@kroah.com> wrote:
> So, are you happy with this in Linus's tree, or do you want it
> reverted?

The problems with this patch include:
1. There's at least one subtlety I overlooked - switching between X servers
   (i.e. from one X VT to another) still requires the cooperation of both
   X servers. I was assuming that KMS eliminated this.
2. It hasn't been tested at all (no X server patch exists which uses the
   new mode).

So yes, I think it would be wise to revert it. I'll resubmit the patch (in
a changed form or otherwise) when I've resolved these issues.

I apologize again for being late in telling you this stuff.

Ari
