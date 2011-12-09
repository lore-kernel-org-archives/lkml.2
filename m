Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1LIKcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:32:36 -0500
Received: from ozlabs.org ([203.10.76.45]:53385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1LIKcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:32:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect descriptors
In-Reply-To: <1323340668.3904.21.camel@lappy>
References: <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <1323000831.4205.4.camel@lappy> <20111204162221.GB22501@redhat.com> <1323020088.3256.3.camel@lappy> <4EDBAFC5.2010405@redhat.com> <1323020374.3256.5.camel@lappy> <1323023039.3256.7.camel@lappy> <1323266565.4009.10.camel@lappy> <20111207154816.GA23845@redhat.com> <87r50fgzyj.fsf@rustcorp.com.au> <1323340668.3904.21.camel@lappy>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 09 Dec 2011 16:03:10 +1030
Message-ID: <87obvifgx5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Dec 2011 12:37:48 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2011-12-08 at 20:14 +1030, Rusty Russell wrote:
> > On Wed, 7 Dec 2011 17:48:17 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Wed, Dec 07, 2011 at 04:02:45PM +0200, Sasha Levin wrote:
> > > > On Sun, 2011-12-04 at 20:23 +0200, Sasha Levin wrote:
> > > > 
> > > > [snip]
> > > > 
> > > > Rusty, Michael, does the below looks a reasonable optimization for you?
> > > 
> > > OK overall but a bit hard to say for sure as it looks pretty incomplete ...
> > 
> > A static threshold is very hackish; we need to either initialize it to
> > a proven-good value (since noone will ever change it) or be cleverer.
> 
> I'll better wait to see how the threshold issue is resolved, and
> possibly do it as a dynamic value which depends on the threshold.
> 
> I doubt theres one magic value which would work for all.

Sure, but if it's generally better than the current value, I'll apply it.

Cheers,
Rusty.
