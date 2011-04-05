Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1DEPab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:30:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41571 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab1DEPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:30:29 -0400
Message-ID: <4D9B3581.6080105@zytor.com>
Date: Tue, 05 Apr 2011 08:30:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-10-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-10-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 07:58 AM, Michal Marek wrote:
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  arch/x86/boot/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index f7cb086..7a70c60 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -13,7 +13,7 @@
>  # This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
>  # the default of FLOPPY is used by 'build'.
>  
> -ROOT_DEV	:= CURRENT
> +ROOT_DEV	?= CURRENT
>  
>  # If you want to preset the SVGA mode, uncomment the next line and
>  # set SVGA_MODE to whatever number you want.

Is this a good thing?  As far as I understand ?= it may mean picking
something up from the outside environment.

Since ROOT_DEV has been obsolete for 15 years or more, this would seem
to be a needless new error mode.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

