Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2EHSGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:06:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2EHSGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:06:32 -0400
Message-ID: <4FA96092.2090004@zytor.com>
Date: Tue, 08 May 2012 11:06:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
References: <cover.1334833140.git.mst@redhat.com> <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com> <4FA93B3F.3000906@redhat.com> <20120508152843.GE8988@redhat.com> <4FA93FA3.20306@zytor.com> <20120508165736.GA26795@redhat.com>
In-Reply-To: <20120508165736.GA26795@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 09:57 AM, Michael S. Tsirkin wrote:
> 
> Will do. OK to only define them for x86 for now?
> They would be unused on other arches even if I defined them ...
> 

I don't know if it's possible/practical to define them so they fall back
to the fully atomic versions unless arch-overridden, but that would be
the best, I would think.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

