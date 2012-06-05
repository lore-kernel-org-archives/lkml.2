Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526Ab2FEJbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:31:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34622 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761458Ab2FEJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:31:18 -0400
X-Sasl-enc: kk4CpqAiBU/bkiUtu+p5DWYptJYNQwJbu4UkYzi5DaPf 1338888677
Date: Tue, 5 Jun 2012 18:31:15 +0900
From: Greg KH <greg@kroah.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, jmoyer@redhat.com,
        mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        joe.jin@oracle.com, dave.kleikamp@oracle.com
Subject: Re: [V2 PATCH 2/2] ocfs2: clear unaligned io flag when dio fails
Message-ID: <20120605093115.GB21560@kroah.com>
References: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
 <1338881210-14863-3-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338881210-14863-3-git-send-email-junxiao.bi@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 03:26:50PM +0800, Junxiao Bi wrote:
> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/file.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
