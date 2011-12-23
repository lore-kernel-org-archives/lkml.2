Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1LWLtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:49:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab1LWLtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:49:51 -0500
Date: Fri, 23 Dec 2011 12:49:39 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udf: Mark LVID buffer as uptodate before marking it
 dirty
Message-ID: <20111223114939.GC22691@quack.suse.cz>
References: <1324638633-25230-1-git-send-email-jack@suse.cz>
 <CAKYAXd83vzH7j0H1HyvFz=ue8bGxFD5vPfyyN=Spj46dqmO5Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd83vzH7j0H1HyvFz=ue8bGxFD5vPfyyN=Spj46dqmO5Tw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-12-11 20:39:17, Namjae Jeon wrote:
> 2011/12/23 Jan Kara <jack@suse.cz>:
> > When we hit EIO while writing LVID, the buffer uptodate bit is cleared.
> > This then results in an anoying warning from mark_buffer_dirty() when we
> > write the buffer again. So just set uptodate flag unconditionally.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> > ---
> Hi. Jan.
> looks good to me !!.
  Thanks for review!

									Honza
