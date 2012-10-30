Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab2J3Uqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:46:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36950
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178Ab2J3Uqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:46:35 -0400
Date: Tue, 30 Oct 2012 16:46:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121030204633.GA15361@infradead.org>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
 <20121029222613.GU29378@dastard>
 <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:37:06PM +0100, Torsten Kaiser wrote:
> On Mon, Oct 29, 2012 at 11:26 PM, Dave Chinner <david@fromorbit.com> wrote:

For some reason I only managed to get the two mails from Torsten into my
xfs list folder, but the one from Dave is missing.  I did see Dave's
mail in my linux-mm folder, though.

> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I agree that vmap needs to be fixed to pass through the gfp flags
ASAP.

