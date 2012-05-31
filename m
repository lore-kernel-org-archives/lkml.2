Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab2EaXE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:04:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2EaXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:04:56 -0400
Date: Thu, 31 May 2012 16:04:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: William Dauchy <wdauchy@gmail.com>, shli@fusionio.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xensource.com, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
In-Reply-To: <20120529144743.GG3558@phenom.dumpdata.com>
Message-ID: <alpine.LSU.2.00.1205311601480.4561@eggly.anvils>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com> <20120521181558.GA7829@phenom.dumpdata.com> <alpine.LSU.2.00.1205261113470.2033@eggly.anvils> <20120529144743.GG3558@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Konrad Rzeszutek Wilk wrote:
> 
> I think I know and just narrowed down the issue this Friday.
> 
> William, could you please apply the patch outlined in
> https://bugzilla.redhat.com/show_bug.cgi?id=824641
> to your dom0 and see if that (so do not have 052b198 in your branch)
> 
> > 
> > At present I see no connection (beyond the fact that the patch fixes
> > the symptom): in the absence of understanding, I have to beware that
> > the underlying issue may remain unfixed.
> 
> <nods>

Thanks a lot for pursuing that to a much more satisfying conclusion.

Hugh
