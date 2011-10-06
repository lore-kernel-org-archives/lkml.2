Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab1JFVmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:42:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab1JFVmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:42:01 -0400
Date: Thu, 6 Oct 2011 23:41:59 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] udf : enable error print in udf_read_tagged().
Message-ID: <20111006214159.GK31367@quack.suse.cz>
References: <1317650037-4648-1-git-send-email-linkinjeon@gmail.com>
 <20111005220813.GK23467@quack.suse.cz>
 <1317853198.3095.19.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317853198.3095.19.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-10-11 15:19:58, Joe Perches wrote:
> On Thu, 2011-10-06 at 00:08 +0200, Jan Kara wrote:
> > Hello,
> > 
> > On Mon 03-10-11 22:53:57, Namjae Jeon wrote:
> > > While reading metadata, if a problem occurs, Print out only one of the
> > > five case.(It also does not show a checksum properly.) Because currently
> > > it have been disable by undef udf_debug.  If there is a problem with
> > > scratched disc or loader, the user needs to know which error happened.
> > > And I use pr_fmt instead of printk by joe's suggestion. I try to modify
> > > totally it to pr_fmt also.
> 
> >   Thanks for the patch. I'm willing to take the patch since it's an
> > improvement but what would be even nicer is to have error reporting like in
> > ext3 / ext4. We would have functions udf_info, udf_warn, udf_err which
> > also print sb->s_id with each error so that user can better identify on
> > which filesystem error happened.
> 
> Modifying the follow-on patch I sent would be pretty trivial.
  Sure, I can do that but if Namjae is willing to do it, I'd have less work
:).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
