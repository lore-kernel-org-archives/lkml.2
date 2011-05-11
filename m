Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1EKWAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:00:02 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45262 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756033Ab1EKWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:00:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=u0U9l5PAp3b3yh7Kp+pVK4J8o036aKh8+egGeMgiaaxfXExAMWGWxoulCYq3REYNNEhPEVkYBATmQgLfPPYF4jrfZDbWOcJm4r24yEmjdmD8Fv1/095yGiAdEqT6P55A;
Date: Wed, 11 May 2011 14:59:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jan Kara <jack@suse.cz>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] Documentation: Remove the obsolete parameters in 2 jbd2
 functions.
Message-Id: <20110511145957.dff6c0ca.rdunlap@xenotime.net>
In-Reply-To: <20110511145604.GF5057@quack.suse.cz>
References: <1305123521-2896-1-git-send-email-tm@tao.ma>
	<20110511145604.GF5057@quack.suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 16:56:04 +0200 Jan Kara wrote:

> On Wed 11-05-11 22:18:41, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > credits isn't a parameter for jbd2_journal_get_write_access and
> > jbd2_journal_get_undo_access. So remove the corresponding comments.
> > 
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>   For JBD2 changes please CC also Ted Ts'o <tytso@mit.edu> since he is
> merging JBD2 patches. The patch is fine. Thanks.

Yes, normally Ted should merge this patch, not me.

Ted, do you need to have it resent to you?

Thanks.

> 								Honza
> > ---
> >  fs/jbd2/transaction.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 05fa77a..0a82612 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -813,7 +813,6 @@ out:
> >   * int jbd2_journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
> >   * @handle: transaction to add buffer modifications to
> >   * @bh:     bh to be used for metadata writes
> > - * @credits: variable that will receive credits for the buffer
> >   *
> >   * Returns an error code or 0 on success.
> >   *
> > @@ -931,7 +930,6 @@ out:
> >   *     non-rewindable consequences
> >   * @handle: transaction
> >   * @bh: buffer to undo
> > - * @credits: store the number of taken credits here (if not NULL)
> >   *
> >   * Sometimes there is a need to distinguish between metadata which has
> >   * been committed to disk and that which has not.  The ext3fs code uses
> > -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
