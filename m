Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1KHJ17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1KHJ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:27:56 -0500
Date: Tue, 8 Nov 2011 10:27:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] MAINTAINERS: Update KVM doc path
In-Reply-To: <1320455660-20989-1-git-send-email-levinsasha928@gmail.com>
Message-ID: <alpine.LNX.2.00.1111081027310.1964@pobox.suse.cz>
References: <1320455660-20989-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011, Sasha Levin wrote:

> Cc: Jiri Kosina <trivial@kernel.org>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 506fe49..0acdc78 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3732,7 +3732,7 @@ M:	Marcelo Tosatti <mtosatti@redhat.com>
>  L:	kvm@vger.kernel.org
>  W:	http://kvm.qumranet.com
>  S:	Supported
> -F:	Documentation/*/kvm.txt
> +F:	Documentation/*/kvm/

By that you are dropping Documentation/ia64/kvm.txt and 
Documentation/s390/kvm.txt from the pattern which I guess is not what you 
want?

>  F:	arch/*/kvm/
>  F:	arch/*/include/asm/kvm*
>  F:	include/linux/kvm*
> -- 
> 1.7.7.2
> 

-- 
Jiri Kosina
SUSE Labs
