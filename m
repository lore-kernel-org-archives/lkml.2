Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2EGLsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab2EGLsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:48:00 -0400
Message-ID: <4FA7B66B.5090105@redhat.com>
Date: Mon, 07 May 2012 14:47:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] apic: eoi optimization support
References: <cover.1334833140.git.mst@redhat.com> <20120507103512.GG23002@gmail.com> <20120507105910.GA18943@redhat.com> <20120507114001.GA15186@gmail.com>
In-Reply-To: <20120507114001.GA15186@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 02:40 PM, Ingo Molnar wrote:
> > > 
> > > No objections from the x86 side.
> > 
> > Is kvm.git a good tree to merge this through?
>
> Fine to me, but I haven't checked how widely it conflicts with 
> existing bits: by the looks of it most of the linecount is on 
> the core x86 side, while the kvm change is well concentrated.

I don't see a problem with merging though tip.git - we're close to the
next merge window, and the guest side rarely causes conflicts.  But
please don't apply the last patch yet, I want to review it more closely
(esp. with the host side).

-- 
error compiling committee.c: too many arguments to function

