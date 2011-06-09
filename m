Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab1FIN6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:58:00 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48859 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab1FIN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:57:58 -0400
Date: Thu, 9 Jun 2011 14:57:51 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-ID: <20110609135751.GE13242@shadowen.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org>
 <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608205233.ebfedc4d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:

> Another issue: there have been numerous attempts at Linux overlay
> filesystems from numerous parties.  Does (or will) this implementation
> satisfy all their requirements?
> 
> Because if not, we're in a situation where the in-kernel code is
> unfixably inadequate so we end up merging another similar-looking
> thing, or the presence of this driver makes it harder for them to get
> other drivers merged and the other parties' requirements remain
> unsatisfied.

>From what I have seen the main advantage of the overlayfs implementation
is its simplicity.  It allows you to layer exactly two things.  That said,
in testing overlayfs seems perfectly happy to take its own mounts and
further union them providing the flexibility that other union mounts
implmentations provide.

-apw
