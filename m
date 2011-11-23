Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1KWUIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:08:47 -0500
Received: from smtp13.mail.ru ([94.100.176.90]:40127 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab1KWUIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:08:46 -0500
Date: Thu, 24 Nov 2011 00:08:43 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, pebolle@tiscali.nl
Subject: Re: [RFC V4]Trivial: Fix typos in various parts of the kernel, and
 fix some comments.
Message-ID: <20111123200842.GA23790@rainbow>
References: <1322062588-4318-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322062588-4318-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:36 Wed 23 Nov     , Justin P. Mattock wrote:

> --- a/tools/power/cpupower/debug/i386/intel_gsic.c
> +++ b/tools/power/cpupower/debug/i386/intel_gsic.c
> @@ -53,7 +53,7 @@ int main (void)
>  			       "RISK.\n");
>  		}
>  		if ((r.ebx & 0xffff) != 0xb2) {
> -			printf("non-default command port. If speedstep-smi "
> +			printf("non-default command port. If spedstep-smi "

"spedstep"? Looks like your sed was too overzealous :)

-- 
Best regards,
Dmitry "MAD" Artamonow

