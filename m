Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab0EMSnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:43:13 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54300 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab0EMSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=wfSsI4HYrk/dsACYzIQra1AqLzZD8YQV6BkTXVhEICOPrfAauzwmfWNmta+d5S6B/z
         PmMnLJsktPsOHtAqmaeSNyzKBr62UltUZYq1ehbgM9uX21V6naU8WvHaEk9Q/fAmuNMa
         uyAVaEqSMvMmFNJahSZmXWc1LY/3BwXJbIN/4=
Date: Thu, 13 May 2010 20:42:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] libsas: dereferencing variable before check
Message-ID: <20100513184232.GC5695@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100512225629.GB5695@bicker> <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com> <1273761114.4353.122.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273761114.4353.122.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 09:31:54AM -0500, James Bottomley wrote:
> On Thu, 2010-05-13 at 01:08 +0200, Tejun Heo wrote:
> > 
> > "Dan Carpenter" <error27@gmail.com> wrote:
> > 
> > >The "qc->scsicmd" could be null so I moved the dereference inside the
> > >check.  This was introduced by 70b25f890: "[SCSI] fix locking around
> > >blk_abort_request()" 
> > >
> > >Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > Ooh.. right.
> > 
> > Asked-by: Tejun Heo <tj@kernel.org>
> 
> Well, oops, yes.  Two patches to fix one bug is a bit overboard, I
> think, plus some code rearrangement to fix the locality of the problem
> and ensure it doesn't happen again might be useful.  What about this.
> 

Looks good.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

