Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1LAUMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:12:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38221 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1LAUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:12:47 -0500
Date: Thu, 1 Dec 2011 12:12:37 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5.1 00/14] crc32c: Add faster algorithm and self-test
	code
Message-ID: <20111201201237.GB23175@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com> <20111130142911.673c2d99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130142911.673c2d99.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11120120-9360-0000-0000-000001288BA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 02:29:11PM -0800, Andrew Morton wrote:
> On Mon, 28 Nov 2011 14:36:59 -0800
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> > software crc32c implementation.
> 
> I think the attributions here are all messed up.  As the patches stand,
> it appears that you wrote all of them.  But I don't think that is the
> case.
> 
> If Bob wrote a particular patch then that patch should be sent with a
> From: Bob Pearson <rpearson@systemfabricworks.com> right at the start
> of the changelog so that he is recorded as the primary author.  If the
> email sender (ie: you) was the primary author then this attribution can
> be omitted and we fall back to using the From: from the email headers.
> 
> Also, every one of these patches should have you own signed-off-by,
> regardless of its authorship.  For reasons explained in
> Documentation/SubmittingPatches, section 12.
> 
> Please fix these things up and resend.
> 
> Also, it would be conventional and useful if each patch title was
> prefixed by its subsystem identifier.  ie, "removed two instances of
> trailing whitespaces" should be titled "crc32: remove two instances of
> trailing whitespace" or "lib/crc32.c: remove two instances of trailing
> whitespaces".

Okay, I'll massage the changelogs to give them more descriptive subjects, and
fix the attribution chain.  Thank you for the feedback.

--D
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

