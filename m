Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab0GWPhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:37:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473Ab0GWPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:37:35 -0400
Date: Fri, 23 Jul 2010 08:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, jmorris@namei.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
Message-Id: <20100723083706.627a4361.akpm@linux-foundation.org>
In-Reply-To: <201007231407.51605.helmut.schaa@googlemail.com>
References: <201006091227.15729.helmut.schaa@googlemail.com>
	<5204AD54-F4BF-49A8-9168-3FCA112AAA2B@linux.vnet.ibm.com>
	<20100623130700.a032c373.akpm@linux-foundation.org>
	<201007231407.51605.helmut.schaa@googlemail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:07:51 +0200 Helmut Schaa <helmut.schaa@googlemail.com> wrote:

> Hi,
> 
> Am Mittwoch 23 Juni 2010 schrieb Andrew Morton:
> > On Wed, 23 Jun 2010 16:55:54 -0300
> > Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> > 
> > > > (top-posting repaired.  Please don't do that).
> > > > 
> > > > This wasn't a very good way to send a patch.  I edited the diff,
> > > > reconstructed the patch and then assembled a decent-looking changelog. 
> > > > I also changed your acked-by to the required signed-off-by, because you
> > > > were on the patch's delivery path.
> > > > 
> > > > Pretty please: next time, prepare a proper mergeable patch with the
> > > > correct attributions and signoffs?  Thanks.
> > > 
> > > Sure, sorry. I was just not certain if I could just resent Helmut's patch to LKML without messing with his authorship.
> > 
> > You can.  Put his "From:" line right at the top of the changelog and
> > everyone's patch-receiving tools will honour that.  If the From: at the
> > top of the changelog is absent, the tools will fall back to using the
> > From: line in the mail headers.
> 
> This patch still didn't make it into mainline and it fixes a regression.
> Rajiv, do you plan to resubmit the patch or did you expect it to go through
> Andrew's tree?

The patch is presently parked in James's linux-next tree.
