Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0HMHSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:18:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41816 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0HMHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:18:43 -0400
Date: Fri, 13 Aug 2010 00:17:25 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        "Patrick J. LoPresti" <lopresti@gmail.com>, ocfs2-devel@oss.oracle.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 2/3] JBD2: Allow feature checks before
 journal recovery
Message-ID: <20100813071720.GA21279@mail.oracle.com>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <874ofr2myq.fsf@patl.com>
 <8739vb2mxr.fsf@patl.com>
 <20100812174318.GD6561@mail.oracle.com>
 <20100813033930.GG2763@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813033930.GG2763@thunk.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 11:39:30PM -0400, Ted Ts'o wrote:
> On Thu, Aug 12, 2010 at 10:43:19AM -0700, Joel Becker wrote:
> > On Thu, Jul 22, 2010 at 03:04:16PM -0700, Patrick J. LoPresti wrote:
> > > Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
> > > confirm that its journal supports 64-bit offsets.  In particular, we
> > > need to check the journal's feature bits before recovering the journal.
> > > 
> > > This is not possible with JBD2 at present, because the journal
> > > superblock (where the feature bits reside) is not loaded from disk until
> > > the journal is recovered.
> > > 
> > > This patch loads the journal superblock in
> > > jbd2_journal_check_used_features() if it has not already been loaded,
> > > allowing us to check the feature bits before journal recovery.
> > > 
> > > Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> > 
> > Dear jbd2 developers,
> > 	I've pushed this patch to the merge-window branch of ocfs2.git.
> > I'm ready to send it to Linus, but I need your OK.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

	Thanks Ted!

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
