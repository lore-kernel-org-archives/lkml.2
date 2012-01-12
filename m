Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2ALVi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:38:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab2ALViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:38:55 -0500
Date: Thu, 12 Jan 2012 22:38:53 +0100
From: Jan Kara <jack@suse.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>, Surbhi Palande <csurbhi@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Message-ID: <20120112213853.GG8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <20120112204826.GG6626@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112204826.GG6626@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-01-12 15:48:26, Ted Tso wrote:
> On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> > reproduce deadlocks due to dirty data as well so please test these patches out.
> > Thanks. Also review of patches is welcome.
> 
> This patch series looks good to me (modulo issues others have already
> pointed out).
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
  Thanks.

> I assume you're going to send this up through Al's vfs tree?
  Yes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
