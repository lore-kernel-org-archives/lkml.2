Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0FDJLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:11:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0FDJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:11:54 -0400
Message-ID: <4C08C358.1040406@suse.cz>
Date: Fri, 04 Jun 2010 11:11:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
Cc: Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] .gitignore arch/x86/boot/compressed/vmlinux
References: <1274145823-24137-1-git-send-email-walken@google.com>
In-Reply-To: <1274145823-24137-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.5.2010 03:23, Michel Lespinasse wrote:
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  arch/x86/boot/compressed/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
> index 4a46fab..b71c8ca 100644
> --- a/arch/x86/boot/compressed/.gitignore
> +++ b/arch/x86/boot/compressed/.gitignore
> @@ -1,4 +1,5 @@
>  relocs
> +vmlinux


Hi,

this is already ignored by arch/x86/.gitignore in linux-next.

Michal
