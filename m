Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab1JNTjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:39:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab1JNTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:39:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=TptbhbcsQhmplXVIzXg8LCZR0YxqAELjLVqaoNv11EObOLmbxcfwFq1pr0idLLKGG
	o5G1jUGlStgBgs9uZQhdw==
Date: Fri, 14 Oct 2011 12:38:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Bolle <pebolle@tiscali.nl>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] x86: drop unused Kconfig symbol
In-Reply-To: <1318595423.6132.75.camel@x61.thuisdomein>
Message-ID: <alpine.DEB.2.00.1110141236330.24783@chino.kir.corp.google.com>
References: <1318595423.6132.75.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: David Rientjes <rientjes@google.com>

The last instance of this option was removed in e56b3bc79429 
("cpu masks: optimize and clean up cpumask_of_cpu()") back in mid-2008.

> ---
>  arch/x86/Kconfig |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6a47bb2..18f74ed 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -192,9 +192,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>  config NEED_PER_CPU_PAGE_FIRST_CHUNK
>  	def_bool y
>  
> -config HAVE_CPUMASK_OF_CPU_MAP
> -	def_bool X86_64_SMP
> -
>  config ARCH_HIBERNATION_POSSIBLE
>  	def_bool y
>  
