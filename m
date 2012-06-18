Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2FRJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:29:25 -0400
Received: from ozlabs.org ([203.10.76.45]:59585 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2FRJ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:29:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear functions
In-Reply-To: <4FDA304C.4050306@zytor.com>
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com> <20120613140404.GH5979@phenom.dumpdata.com> <4FD8AB07.7080004@citrix.com> <20120614182913.GA21956@phenom.dumpdata.com> <4FDA304C.4050306@zytor.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 18 Jun 2012 18:43:28 +0930
Message-ID: <87bokhyocn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 11:41:16 -0700, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 06/14/2012 11:29 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > Lets rope Rusty in this since he is the maintainer of lguest.
> >
> 
> Also, let's have realistic expectations for lguest.
> 
> I don't want to break lguest just for sh*ts and giggles, but if lguest
> is in the way of making forward progress for other things, it would have
> to have a very strong case to not be sacrificed.

Exactly!  Please cc' me if you need me to unbreak lguest, but for
performance?  Not really...

Cheers,
Rusty.
