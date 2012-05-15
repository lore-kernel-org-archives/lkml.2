Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab2EOL0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:26:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56411 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2EOL0O convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:16:3>);
	Tue, 15 May 2012 07:26:14 -0400
Message-Id: <4FB2598D0200007800083C55@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 12:26:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: "Stephan Diestelhorst" <stephan.diestelhorst@amd.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Attilio Rao" <attilio.rao@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, "X86" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Raghavendra K T" <raghavendra.kt@linux.vnet.ibm.com>,
        "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
        "Virtualization" <virtualization@lists.linux-foundation.org>,
        "Xen Devel" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Avi Kivity" <avi@redhat.com>, "Gleb Natapov" <gleb@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, "KVM" <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH RFC V8 0/17] Paravirtualized ticket
 spinlocks
References: <4FA7BABA.4040700@redhat.com>
 <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com>
 <4FA7D06B.60005@linux.vnet.ibm.com>
 <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com>
 <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com>
 <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com>
 <20120507172527.GA5357@gmail.com>
In-Reply-To: <20120507172527.GA5357@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.05.12 at 19:25, Ingo Molnar <mingo@kernel.org> wrote:

(apologies for the late reply, the mail just now made it to my inbox
via xen-devel)

> I'll hold off on the whole thing - frankly, we don't want this 
> kind of Xen-only complexity. If KVM can make use of PLE then Xen 
> ought to be able to do it as well.

It does - for fully virtualized guests. For para-virtualized ones,
it can't (as the hardware feature is an extension to VMX/SVM).

> If both Xen and KVM makes good use of it then that's a different 
> matter.

I saw in a later reply that you're now tending towards trying it
out at least - thanks.

Jan

