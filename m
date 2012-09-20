Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2ITXwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:52:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2ITXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:52:04 -0400
Date: Thu, 20 Sep 2012 16:51:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 09/26] block: Remove some unnecessary bi_vcnt usage
Message-ID: <20120920235159.GP7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-10-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-10-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:20PM -0700, Kent Overstreet wrote:
> More prep work for immutable bvecs/effecient bio splitting - usage of
> bi_vcnt has to be auditing, so getting rid of all the unnecessary usage
> makes that easier.
> 
> Plus, bio_segments() is really what this code wanted, as it respects the
> current value of bi_idx.

Looks good to me but definitely need reviews from SCSI people.

Thanks.

-- 
tejun
