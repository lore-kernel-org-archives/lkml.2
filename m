Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0GFTJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 15:09:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51785 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0GFTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 15:09:22 -0400
Date: Tue, 6 Jul 2010 12:06:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
Message-ID: <20100706190650.GE17961@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mfasheh@suse.com>
References: <20100628173529.GA10573@mail.oracle.com>
 <20100629002421.GY6590@dastard>
 <20100629005403.GC24343@mail.oracle.com>
 <AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
 <20100629015822.GD24343@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629015822.GD24343@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C337F41.012A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 06:58:23PM -0700, Joel Becker wrote:
> 	Oh, no, that's not it at all.  This is a disaster.  I can't see
> for the life of me why we haven't had 100,000 bug reports.  You're going

	Btw, we've figured out why we don't have 100,000 bug reports.
Most normal usage will never encounter this.  But it is still a serious
problem, and the fix is just as high a priority.

Joel

P.S.: Thanks, LWN, for making me look good on the QotW ;-)

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
