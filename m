Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1GBWcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 18:32:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48136 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1GBWcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 18:32:11 -0400
Message-ID: <4E0F9C3F.8020907@zytor.com>
Date: Sat, 02 Jul 2011 15:31:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] merge 32 and 64 realmode wakeup code
References: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
In-Reply-To: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2011 10:43 AM, Matthieu CASTET wrote:
> - this mean less ifdef in code
> - we could remove now unused field in wakeup_header (pmode_*)
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> ---
>  arch/x86/kernel/acpi/realmode/wakeup.S |   26 --------------------------
>  arch/x86/kernel/acpi/sleep.c           |   27 ++++++++++-----------------
>  arch/x86/kernel/trampoline_32.S        |    4 ----
>  3 files changed, 10 insertions(+), 47 deletions(-)
> 

Looks great to me.  Rafael?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

