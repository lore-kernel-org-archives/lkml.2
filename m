Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0KLIxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:53:50 -0500
Received: from mail.perches.com ([173.55.12.10]:4979 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0KLIxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:53:50 -0500
Subject: Re: [Jfs-discussion] [PATCH 5/6] fs/jfs: Add printf
 format/argument verification
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net
In-Reply-To: <1289489501.6848.13.camel@shaggy-w500>
References: <cover.1289432524.git.joe@perches.com>
	 <a22ba4f754931aabc3928435e613a1b809d31f9e.1289432524.git.joe@perches.com>
	 <1289489501.6848.13.camel@shaggy-w500>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 00:53:47 -0800
Message-ID: <1289552027.6519.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 09:31 -0600, Dave Kleikamp wrote:
> On Wed, 2010-11-10 at 15:46 -0800, Joe Perches wrote:
> > Add __attribute__((format... to jfs_error.
> > All arguments matched formats, no other changes necessary.
> > Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Would you like to push this patchset as a group, or would you like me to
> push this patch through the jfs tree?

I think each patch should go through the
appropriate fs maintainers separately.

cheers, Joe

