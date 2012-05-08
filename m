Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2EHTgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab2EHTgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:36:13 -0400
Date: Tue, 8 May 2012 22:36:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
Message-ID: <20120508193612.GD28536@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
 <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
 <4FA93B3F.3000906@redhat.com>
 <20120508152843.GE8988@redhat.com>
 <4FA93FA3.20306@zytor.com>
 <20120508165736.GA26795@redhat.com>
 <4FA96092.2090004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA96092.2090004@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:06:10AM -0700, H. Peter Anvin wrote:
> On 05/08/2012 09:57 AM, Michael S. Tsirkin wrote:
> > 
> > Will do. OK to only define them for x86 for now?
> > They would be unused on other arches even if I defined them ...
> > 
> 
> I don't know if it's possible/practical to define them so they fall back
> to the fully atomic versions unless arch-overridden, but that would be
> the best, I would think.

Ah, good idea, will do.

