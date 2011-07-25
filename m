Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1GYTWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:22:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:33348 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1GYTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:22:18 -0400
Date: Mon, 25 Jul 2011 12:21:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
In-Reply-To: <1311597387.14203.23.camel@jaguar>
Message-ID: <alpine.DEB.2.02.1107251219410.14943@asgard.lang.hm>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>  <4E2CA6DE.4040900@web.de>  <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>  <20110725075305.GA32294@elte.hu>  <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>  <20110725103817.GA21683@infradead.org>
 <1311597387.14203.23.camel@jaguar>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011, Pekka Enberg wrote:

> I don't think toyvisor2 will do, really. I originally wanted to call the
> hypervisor 'pvm' for selfish reasons because quite frankly 'penix' just
> doesn't have the prestige 'linux' has. However, Ingo convinced me that
> 'kvm' is a good name and I agree with that.
>
> I'm open to alternative suggestions, though.

I don't have a suggestions, but KVM is already a common acronym in 
datacenters, referring to 'Keyboard Video Mouse" consoles (and associated 
switching systems)

it would be nice to to have this sort of conflict with a new name.

David Lang
