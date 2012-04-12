Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2DLEJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2DLEJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:09:09 -0400
Date: Wed, 11 Apr 2012 22:15:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kvm-amd: Auto-load on CPUs with SVM.
Message-ID: <20120412011542.GA2211@amt.cnet>
References: <20120321063350.GA3468@leaf>
 <4F72F549.6060407@redhat.com>
 <20120328183228.GA24889@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328183228.GA24889@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:32:28AM -0700, Josh Triplett wrote:
> Enable x86 feature-based autoloading for the kvm-amd module on CPUs
> with X86_FEATURE_SVM.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> On Wed, Mar 28, 2012 at 01:26:01PM +0200, Avi Kivity wrote:
> > On 03/21/2012 08:33 AM, Josh Triplett wrote:
> > > Enable x86 feature-based autoloading for the kvm-intel module on CPUs
> > > with X86_FEATURE_VMX.
> > 
> > Thanks, applied.
> 
> As promised, the corresponding patch for kvm-amd.
> 
>  arch/x86/kvm/svm.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

Applied, thanks.

