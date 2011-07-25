Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1GYNKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:10:31 -0400
Received: from 8bytes.org ([88.198.83.132]:56121 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1GYNKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:10:24 -0400
Date: Mon, 25 Jul 2011 15:10:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725131022.GJ24072@8bytes.org>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com> <ECCD7C67-C339-43EA-8A57-513173899813@suse.de> <4E2D2AE8.7050100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2D2AE8.7050100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:35:52AM +0300, Avi Kivity wrote:
> On 07/25/2011 11:31 AM, Alexander Graf wrote:
>> In Ingo's reasoning, the next step would be to rewrite glibc and put
>> it into the kernel tree, because we end up adding syscalls so adding
>> them to the in-kernel libc with the same commit would be a lot easier
>> and cleaner.
>
> That actually makes a ton of sense.  One immediate win would be that  
> klibc can be tuned to the kernel it ships with (the dynamic loader will  
> pick the correct object), so less #ifdef trees.  Another would be to  
> make klibc the formal kernel interface, which allows us to reimplement  
> an older interface in terms of the one that supercedes it.

A libc in the kernel tree would indeed make a lot of sense and I am all
for it :) It would also help to get new interfaces to the users faster.
But it should probably not be the primary exported interface. This would
just move the compatability problem from the kernel into user-space.

	Joerg

