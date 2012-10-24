Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab2JXJBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:01:36 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:46111 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab2JXJBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:01:34 -0400
Date: Wed, 24 Oct 2012 11:01:25 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 026/193] arch/s390/kvm: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024110125.6c8a3589@BR9GNB5Z>
In-Reply-To: <1351022666-6960-27-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-27-git-send-email-keescook@chromium.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102409-6892-0000-0000-000003548E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 13:01:39 -0700
Kees Cook <keescook@chromium.org> wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Avi Kivity <avi@redhat.com>
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Christian Borntraeger <borntraeger@de.ibm.com>
> CC: Cornelia Huck <cornelia.huck@de.ibm.com>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

> ---
>  arch/s390/kvm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index b58dd86..60f9f8a 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -18,7 +18,7 @@ if VIRTUALIZATION
>  config KVM
>  	def_tristate y
>  	prompt "Kernel-based Virtual Machine (KVM) support"
> -	depends on HAVE_KVM && EXPERIMENTAL
> +	depends on HAVE_KVM
>  	select PREEMPT_NOTIFIERS
>  	select ANON_INODES
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT

