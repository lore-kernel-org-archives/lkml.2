Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2K0AxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:53:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab2K0AxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:53:15 -0500
Date: Mon, 26 Nov 2012 22:53:05 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Linux KVM mailing list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint
Message-ID: <20121127005305.GB6329@amt.cnet>
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
 <1353537681-18759-1-git-send-email-hpa@linux.intel.com>
 <50B318C5.8090508@redhat.com>
 <50B3F1D2.4010200@linux.intel.com>
 <20121126234820.GA2363@amt.cnet>
 <50B40010.5050007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B40010.5050007@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 03:49:36PM -0800, H. Peter Anvin wrote:
> On 11/26/2012 03:48 PM, Marcelo Tosatti wrote:
> >>
> >> Gleb, Marcelo: are you going to apply this or would you prefer I took it
> >> in x86/urgent?
> >>
> >> 	-hpa
> > 
> > Feel free to merge it through x86/urgent.
> > 
> 
> I presume that's an Acked-by?
> 
> 	-hpa

Yes.

