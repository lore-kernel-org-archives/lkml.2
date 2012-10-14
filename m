Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2JNP4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:56:41 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:49666 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2JNP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:56:40 -0400
Date: Sun, 14 Oct 2012 17:55:38 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dmarkh@cfl.rr.com, markh@compro.net,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
Message-ID: <20121014175538.3bdd7cb8@neptune.home>
In-Reply-To: <CAKMK7uGCyHaXko102_VDus3RCarDobeiRcNKnzjqX3YFK2ouBw@mail.gmail.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
	<507A91EA.2030205@cfl.rr.com>
	<CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
	<507AC9DC.4030701@cfl.rr.com>
	<CAKMK7uERj4+QtxMzzHsbxbqvUYNGWxmieZeebS3+CjAbj6Kq1g@mail.gmail.com>
	<507ADD14.7050503@cfl.rr.com>
	<CAKMK7uGCyHaXko102_VDus3RCarDobeiRcNKnzjqX3YFK2ouBw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 October 2012 Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Oct 14, 2012 at 5:41 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> > There is something amiss. Here is my  i915_pci_probe routine. I Added a
> > couple more printks. NONE of these show up in dmesg. Not even the "Entered"
> > printk. ????
> 
> That's rather strange indeed. Is there another driver bound by
> accident to the intel graphics? You can check that with lspci -k
> -Daniel

A few mails ago in a kernel cmd I saw a nomodeset, could it be that
it's still around?

Bruno
