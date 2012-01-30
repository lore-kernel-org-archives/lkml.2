Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2A3FzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:55:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50853 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2A3FzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:55:05 -0500
Date: Sun, 29 Jan 2012 21:54:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Message-ID: <20120130055459.GJ17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <20120129192447.GB17211@htj.dyndns.org>
 <4F25F5F3.6060507@gmail.com>
 <20120130014703.GG17211@htj.dyndns.org>
 <4F25FEE5.5010309@gmail.com>
 <20120130023012.GH17211@htj.dyndns.org>
 <4F260547.1030405@gmail.com>
 <20120130025326.GI17211@htj.dyndns.org>
 <4F262FEF.9020406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F262FEF.9020406@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 02:51:43PM +0900, Namhyung Kim wrote:
> Hi,
> 
> 2012-01-30 11:53 AM, Tejun Heo wrote:
> >Hello,
> >
> >On Mon, Jan 30, 2012 at 11:49:43 AM +0900, Namhyung Kim wrote:
> >>Yes, blktrace will see both of completions for rq and bio's it
> >>contains from now on, and I thought it's your intention? For the
> >>bounced bio's, it'll see one more completion per bio.
> >
> >Umm... no, blktrace users shouldn't see confusing outputs.  My point
> >was that we should leave raw tracepoints as raw monitor points so that
> >they can provide raw data to different users and filter from
> >blktrace.c so that the existing users aren't disturbed.
> >
> 
> That means blktrace should not be changed, and not see duplicated
> completions for rq based drivers at all?

Yeap

-- 
tejun
