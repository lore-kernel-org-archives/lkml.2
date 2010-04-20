Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0DTOi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:38:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:50037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0DTOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:38:57 -0400
Date: Tue, 20 Apr 2010 16:38:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix typo in percpu.h
In-Reply-To: <1271703076-4395-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1004201638090.7579@pobox.suse.cz>
References: <1271703076-4395-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, Justin P. Mattock wrote:

> Fix a typo in arch/x86/include/asm/percpu.h
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/x86/include/asm/percpu.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index 66a272d..9899afa 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -105,7 +105,7 @@ do {							\
>  
>  /*
>   * Generate a percpu add to memory instruction and optimize code
> - * if a one is added or subtracted.
> + * if one is added or subtracted.
>   */

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
