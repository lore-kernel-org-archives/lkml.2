Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2IQVJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:09:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32825 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2IQVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:09:49 -0400
Date: Mon, 17 Sep 2012 14:09:45 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org, neilb@suse.de
Subject: Re: [PATCH v2 25/26] bio-integrity: Add explicit field for owner of
 bip_buf
Message-ID: <20120917210945.GD14492@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-26-git-send-email-koverstreet@google.com>
 <yq1sjanrpu7.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1sjanrpu7.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:41:36PM -0400, Martin K. Petersen wrote:
> >>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:
> 
> Kent> This was the only real user of BIO_CLONED, which didn't have very
> Kent> clear semantics. Convert to its own flag so we can get rid of
> Kent> BIO_CLONED.
> 
> I already have a patch in my queue that moves all integrity-relevant
> flags from struct bio to the bip. So I'm ok with removing BIO_CLONED but
> I'll send a separate patch for the integrity flags.

Cool - have a git repo I can take a look at?
