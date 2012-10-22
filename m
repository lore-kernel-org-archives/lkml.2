Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2JVTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:39:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40103 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2JVTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:39:18 -0400
Date: Mon, 22 Oct 2012 23:39:14 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121022193914.GK2303@moon>
References: <20121022191452.785366817@openvz.org>
 <20121022122934.d2e2fa57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022122934.d2e2fa57.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:29:34PM -0700, Andrew Morton wrote:
> On Mon, 22 Oct 2012 23:14:52 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > Hi guys, during c/r sessions we've found that there is no way at
> > the moment to fetch some VMA associated flags, such as mlock()
> > and madvise(), thus the patches in this series intorduce new field
> > into "smaps" output called VmFlags where all flags associated with
> > the particular VMA is shown in two letter mnemonic.
> > 
> > Strictly speaking for c/r we only need mlock/madvise bits but it
> > has been said that providing just a few flags looks somehow inconsistent.
> > So all flags are here now.
> > 
> > Please review. Comments and complains are quite welcome!
> 
> Sigh, it's still a pretty nasty-looking interface.  Better ideas are
> welcomed.

Well, one usable thing could be (I guess) to print only flags set. Since
usually not that many flags are set on vma. This would shrink output at
least.

> I joined the patches into one, massaged the changelog a bit and added a
> couple more paragraphs explaining why we're doing this to ourselves.

Thanks!
