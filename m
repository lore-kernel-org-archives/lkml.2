Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161012Ab2LGQJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:09:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030757Ab2LGQJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:09:41 -0500
Message-ID: <1354896579.3224.75.camel@bling.home>
Subject: Re: [PATCH 10/10] kvm: Increase user memory slots on x86 to 125
From: Alex Williamson <alex.williamson@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Fri, 07 Dec 2012 09:09:39 -0700
In-Reply-To: <20121207230238.7049d19fe0dc274910fb72da@gmail.com>
References: <20121206214722.24968.6043.stgit@bling.home>
	 <20121206222126.24968.17280.stgit@bling.home>
	 <20121207230238.7049d19fe0dc274910fb72da@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 23:02 +0900, Takuya Yoshikawa wrote:
> On Thu, 06 Dec 2012 15:21:26 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > With the 3 private slots, this gives us a nice round 128 slots total.
> 
> So I think this patch needs to be applied after resolving the
> slot_bitmap issue.  We may not need to protect slots with large
> slot id values, but still it's possible to do so.
> 
> Taking into account that the merge window is so close that this
> patch set should be targeted for 3.9, it may be possible to do
> the work timely: I will post my patch series next week if possible.

This obviously increases the slot_bitmap, actually only doubles it since
it's an unsigned long and we're only using 36 bits, but why should
removing the slot_bitmap gate this series?  Thanks,

Alex

