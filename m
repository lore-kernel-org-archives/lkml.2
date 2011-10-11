Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1JKWfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 18:35:21 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34952 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab1JKWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 18:35:19 -0400
Subject: Re: SCSI trees moved back to kernel.org
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20111012092618.e35391f58873edb1cc0bb5cb@canb.auug.org.au>
References: <1316101053.2983.42.camel@dabdike.hansenpartnership.com>
	 <1318351928.2992.19.camel@dabdike.int.hansenpartnership.com>
	 <20111012092618.e35391f58873edb1cc0bb5cb@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 17:35:16 -0500
Message-ID: <1318372516.2992.32.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 09:26 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> On Tue, 11 Oct 2011 11:52:08 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > OK, all the trees are back in their usual locations on kernel.org,
> > that's
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
> 
> OK, I have switched to use those.  However the last one gives:
> 
> fatal: Couldn't find remote ref refs/heads/merge-base

Um, sorry, fixed I think.  That's what comes of trying to create the
tree without actually having access to the old one.

James



