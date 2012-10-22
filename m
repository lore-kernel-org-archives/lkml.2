Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2JVU4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:56:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53871 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2JVU4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:56:46 -0400
Date: Tue, 23 Oct 2012 00:56:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121022205641.GL2303@moon>
References: <20121022191452.785366817@openvz.org>
 <20121022122934.d2e2fa57.akpm@linux-foundation.org>
 <5085B1A8.4020609@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5085B1A8.4020609@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:50:48AM +0400, Pavel Emelyanov wrote:
> On 10/22/2012 11:29 PM, Andrew Morton wrote:
> > On Mon, 22 Oct 2012 23:14:52 +0400
> > Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> >> Hi guys, during c/r sessions we've found that there is no way at
> >> the moment to fetch some VMA associated flags, such as mlock()
> >> and madvise(), thus the patches in this series intorduce new field
> >> into "smaps" output called VmFlags where all flags associated with
> >> the particular VMA is shown in two letter mnemonic.
> >>
> >> Strictly speaking for c/r we only need mlock/madvise bits but it
> >> has been said that providing just a few flags looks somehow inconsistent.
> >> So all flags are here now.
> >>
> >> Please review. Comments and complains are quite welcome!
> > 
> > Sigh, it's still a pretty nasty-looking interface.  Better ideas are
> > welcomed.
> 
> Maybe just a string of two-letter short names like
> 
> VmFlags: rd wr sh sr
> 
> ?
> 
> I.e. in a way flags line looks in cpuinfo file.

Yup, I think this will be shorter and more agreeable.
