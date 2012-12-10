Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2LJNsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:48:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36380 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2LJNsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:48:52 -0500
Date: Mon, 10 Dec 2012 22:48:47 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 10/10] kvm: Increase user memory slots on x86 to 125
Message-Id: <20121210224847.379ed8bd962937c4c0202253@gmail.com>
In-Reply-To: <1354896579.3224.75.camel@bling.home>
References: <20121206214722.24968.6043.stgit@bling.home>
	<20121206222126.24968.17280.stgit@bling.home>
	<20121207230238.7049d19fe0dc274910fb72da@gmail.com>
	<1354896579.3224.75.camel@bling.home>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 09:09:39 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Fri, 2012-12-07 at 23:02 +0900, Takuya Yoshikawa wrote:
> > On Thu, 06 Dec 2012 15:21:26 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > > With the 3 private slots, this gives us a nice round 128 slots total.
> > 
> > So I think this patch needs to be applied after resolving the
> > slot_bitmap issue.  We may not need to protect slots with large
> > slot id values, but still it's possible to do so.
> > 
> > Taking into account that the merge window is so close that this
> > patch set should be targeted for 3.9, it may be possible to do
> > the work timely: I will post my patch series next week if possible.
> 
> This obviously increases the slot_bitmap, actually only doubles it since
> it's an unsigned long and we're only using 36 bits, but why should
> removing the slot_bitmap gate this series?  Thanks,


I was wrong, sorry.

I thought slot_bitmap was defined as u64 or something, the fact was that
my memory was corrupt.

Thanks,
	Takuya
