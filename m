Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1IFTdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:33:38 -0400
Received: from claw.goop.org ([74.207.240.146]:50950 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1IFTdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:33:31 -0400
Message-ID: <4E667587.8010100@goop.org>
Date: Tue, 06 Sep 2011 12:33:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1109021222080.12963@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1109021222080.12963@kaball-desktop>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 04:22 AM, Stefano Stabellini wrote:
> do you have a git tree somewhere with this series? 

git://github.com/jsgf/linux-xen.git upstream/pvticketlock-slowflag

    J
