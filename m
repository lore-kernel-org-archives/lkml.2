Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2HIGGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:06:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2HIGGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:06:39 -0400
Date: Thu, 9 Aug 2012 02:06:40 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
Message-ID: <20120809060640.GA9088@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-4-git-send-email-koverstreet@google.com>
 <20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809000711.GB7262@moria.home.lan>
 <20120809060019.GA2845@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809060019.GA2845@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:00:19PM -0700, Tejun Heo wrote:
> Anyways, understood.  Can you *please* put some comment what bits are
> being preserved across reset then?  Things like this aren't obvious at
> all and need ample explanation.

I did, in the header:

#define BIO_RESET_BITS	12	/* Flags starting here get preserved by
bio_reset() */

Where the rest of the flags are defined, and near where BIO_RESET_BYTES
are defined.
