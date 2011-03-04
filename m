Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab1CDXP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:15:28 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57776 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1CDXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:15:27 -0500
X-Sasl-enc: 2ogtRwmw/9c6QxmmI44dXj15KVdyfFpfYwWczjOr+12h 1299280526
Message-ID: <4D717289.40403@fastmail.fm>
Date: Fri, 04 Mar 2011 23:15:21 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog, nmi:  Allow hardlockup to panic by default
References: <1299184439-9215-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1299184439-9215-1-git-send-email-dzickus@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 20:33, Don Zickus wrote:
> Add a Kconfig option to allow users to set the hardlockup to panic
> by default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
>
[snip]
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2b97418..80bd292 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -176,6 +176,23 @@ config HARDLOCKUP_DETECTOR
>  	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
>  		 !ARCH_HAS_NMI_WATCHDOG
>  
> +config BOOTPARAM_HARDLOCKUP_PANIC
> +	bool "Panic (Reboot) On Soft Lockups"

Did you mean Hard Lockups here?

Thanks,

Jack
