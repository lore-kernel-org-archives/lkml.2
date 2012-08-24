Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab2HXRDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:03:21 -0400
Received: from twin.jikos.cz ([89.185.236.188]:47272 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2HXRDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:03:19 -0400
X-Greylist: delayed 3035 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 13:03:18 EDT
Date: Fri, 24 Aug 2012 18:12:13 +0200
From: David Sterba <dave@jikos.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, chris.mason@fusionio.com,
        mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Vivek Trivedi <vtrivedi018@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/3] writeback: change nr_pages_dirtied argument into
 local variable
Message-ID: <20120824161213.GB17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Namjae Jeon <linkinjeon@gmail.com>,
	Fengguang Wu <fengguang.wu@intel.com>, chris.mason@fusionio.com,
	mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Vivek Trivedi <vtrivedi018@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <1345283309-7768-1-git-send-email-linkinjeon@gmail.com>
 <20120819021554.GA16796@localhost>
 <CAKYAXd9mSf4bR058-SqpMR_WxDFn5rhF5wGS98ArFaTmp0+YoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9mSf4bR058-SqpMR_WxDFn5rhF5wGS98ArFaTmp0+YoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:06:19PM +0900, Namjae Jeon wrote:
> 2012/8/19, Fengguang Wu <fengguang.wu@intel.com>:
> > On Sat, Aug 18, 2012 at 05:48:29AM -0400, Namjae Jeon wrote:
> >> There is no reason nr_pages_dirtied is argument anymore.
> >> because nr_pages_dirtied value from caller is not used in
> >> balance_dirty_pages_ratelimited_nr function.
> >
> > Looks good to me. If the fs developers don't have problems with this,
> > I'll apply it to the writeback tree.
> Thanks Wu!
> 
> Hi Chris, Mark, Joel.
> 
> Would you check this patch ?

Patch is ok from the btrfs side.

david
