Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab0HMDjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:39:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:56814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0HMDje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:39:34 -0400
Date: Thu, 12 Aug 2010 23:39:30 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, "Patrick J. LoPresti" <lopresti@gmail.com>,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 2/3] JBD2: Allow feature checks before
 journal recovery
Message-ID: <20100813033930.GG2763@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <874ofr2myq.fsf@patl.com>
 <8739vb2mxr.fsf@patl.com>
 <20100812174318.GD6561@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812174318.GD6561@mail.oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:43:19AM -0700, Joel Becker wrote:
> On Thu, Jul 22, 2010 at 03:04:16PM -0700, Patrick J. LoPresti wrote:
> > Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
> > confirm that its journal supports 64-bit offsets.  In particular, we
> > need to check the journal's feature bits before recovering the journal.
> > 
> > This is not possible with JBD2 at present, because the journal
> > superblock (where the feature bits reside) is not loaded from disk until
> > the journal is recovered.
> > 
> > This patch loads the journal superblock in
> > jbd2_journal_check_used_features() if it has not already been loaded,
> > allowing us to check the feature bits before journal recovery.
> > 
> > Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> Dear jbd2 developers,
> 	I've pushed this patch to the merge-window branch of ocfs2.git.
> I'm ready to send it to Linus, but I need your OK.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

	       		       - Ted
