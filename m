Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0GGUFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:05:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59380 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab0GGUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:05:41 -0400
Date: Wed, 7 Jul 2010 13:04:18 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/3] ocfs2: When zero extending, do it by page.
Message-ID: <20100707200418.GB22311@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100703213219.GB21262@mail.oracle.com>
 <1278501367-7710-2-git-send-email-joel.becker@oracle.com>
 <4C349AFF.9040301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C349AFF.9040301@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C34DDEB.01C1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:19:27PM +0800, Tao Ma wrote:
> >+static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
> >+{
> >+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >+	handle_t *handle = NULL;
> >+	int ret = 0;
> >+
> >+	if (ocfs2_should_order_data(inode))
> This should be if (!ocfs2_should_order_data(inode)) I guess? ;)

	Of course it should.  Fixed ;-)

Joel


-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
