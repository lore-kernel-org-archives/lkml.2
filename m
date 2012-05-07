Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2EGL5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:57:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44476 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2EGL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:57:33 -0400
Date: Mon, 7 May 2012 13:57:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] apic: eoi optimization support
Message-ID: <20120507115726.GB15186@gmail.com>
References: <cover.1334833140.git.mst@redhat.com>
 <20120507103512.GG23002@gmail.com>
 <20120507105910.GA18943@redhat.com>
 <20120507114001.GA15186@gmail.com>
 <4FA7B66B.5090105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA7B66B.5090105@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 05/07/2012 02:40 PM, Ingo Molnar wrote:
> > > > 
> > > > No objections from the x86 side.
> > > 
> > > Is kvm.git a good tree to merge this through?
> >
> > Fine to me, but I haven't checked how widely it conflicts with 
> > existing bits: by the looks of it most of the linecount is on 
> > the core x86 side, while the kvm change is well concentrated.
> 
> I don't see a problem with merging though tip.git - we're close to the
> next merge window, and the guest side rarely causes conflicts.  But
> please don't apply the last patch yet, I want to review it more closely
> (esp. with the host side).

That last patch was marked "don't apply yet", so I definitely 
planned on another iteration that incorporates all the feedback 
that has been given.

Thanks,

	Ingo
