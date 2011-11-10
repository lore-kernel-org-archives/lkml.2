Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1KJJvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:51:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab1KJJvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:51:11 -0500
Message-ID: <4EBB9E66.1070609@redhat.com>
Date: Thu, 10 Nov 2011 11:50:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Markus Armbruster <armbru@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain> <4EBB4A21.20707@codemonkey.ws> <alpine.LFD.2.02.1111100829560.1791@tux.localdomain> <m3pqh0tnoi.fsf@blackfin.pond.sub.org> <CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com> <m3fwhws6ci.fsf@blackfin.pond.sub.org> <CA+1xoqc7f-2azcjuLB_i_C_CCDt+gPqJe=SB5MmOiM0y6uY_cg@mail.gmail.com> <4EBB94D9.30906@redhat.com> <CA+1xoqdf2_j4yg=CacMpsDmtz3y30G9_BAyM=Mjsr3rQdAJ+tg@mail.gmail.com> <4EBB9809.1080603@redhat.com> <CA+1xoqdNfX03O6cToOW5wgcbZa7bHvqPPTnMUAH5Ltvs8nMrpg@mail.gmail.com> <4EBB9CA4.3050606@redhat.com> <CA+1xoqfg3sJ7ApWWOuhPCDz+GATY2NMx3r_cKiM9TPpAWYRawQ@mail.gmail.com>
In-Reply-To: <CA+1xoqfg3sJ7ApWWOuhPCDz+GATY2NMx3r_cKiM9TPpAWYRawQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 11:49 AM, Sasha Levin wrote:
> >
> > It does, but the hypervisor can only access the guest's images, and a
> > few internal files (like the qemu-kvm executable and its libraries).
>
> What about devices? You let the guest read and write to devices as
> well (/dev/kvm for example, or network devices).

They're all protected.  /dev/kvm is obviously rw for anyone, but it
can't be used to transfer information.

-- 
error compiling committee.c: too many arguments to function

