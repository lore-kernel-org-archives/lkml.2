Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2JXM4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:56:46 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33663 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2JXM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:56:45 -0400
Date: Wed, 24 Oct 2012 16:56:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -mm] procfs: add VmFlags field in smaps output v3
Message-ID: <20121024125640.GR30983@moon>
References: <20121024122730.GO30983@moon>
 <20121024234714.03b516f6fcb32eb5a27eed1b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024234714.03b516f6fcb32eb5a27eed1b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:47:14PM +1100, Stephen Rothwell wrote:
> Hi Cyrill,
> 
> On Wed, 24 Oct 2012 16:27:30 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> >
> > +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> > +{
> > +	/*
> > +	 * Don't forget to update Documentation/ on changes.
> > +	 */
> > +	static const char mnemonics[BITS_PER_LONG][2] = {
> > +		/*
> > +		 * In case if we meet a flag we don't know about.
> > +		 */
> > +		[0 ... (BITS_PER_LONG-1)] = { "??" },
> 
> Sorry to be picky, but the braces above are unnecessary,

Thanks, Stephen! I'm deferring update for a while, ok? If there will
be no more comments i'll drop the braces a bit later.
