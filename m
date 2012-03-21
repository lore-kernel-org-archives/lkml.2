Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2CUNlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab2CUNls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:41:48 -0400
Message-ID: <4F69DA92.6030107@redhat.com>
Date: Wed, 21 Mar 2012 15:41:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm-intel: Auto-load on CPUs with VMX.
References: <20120321063350.GA3468@leaf>
In-Reply-To: <20120321063350.GA3468@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 08:33 AM, Josh Triplett wrote:
> Enable x86 feature-based autoloading for the kvm-intel module on CPUs
> with X86_FEATURE_VMX.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>
> I've tested this and it works correctly.  I can also supply the obvious
> equivalent patch for kvm-amd on AMD CPUs with SVM, but I don't have any
> such CPUs to test that on.
>

On the one hand this makes sense and is consistent with how other
modules are loaded.  On the other hand this will waste memory for
non-virt users running on distro kernels (but distro kernels can
override this new behaviour anyway).

I'm inclined to apply, but will wait for more comments.

-- 
error compiling committee.c: too many arguments to function

