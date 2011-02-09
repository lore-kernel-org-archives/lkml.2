Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1BIQvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:51:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:56464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab1BIQvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:51:51 -0500
Date: Wed, 9 Feb 2011 08:51:23 -0800
From: Greg KH <gregkh@suse.de>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "amwang@redhat.com" <amwang@redhat.com>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2] Controlling kexec behaviour when hardware
 error happened.
Message-ID: <20110209165123.GA30346@suse.de>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C1494DBE0@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C1494DBE0@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:35:43AM -0500, Seiji Aguchi wrote:
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_KEXEC_ON_HWERR=77, /* int: bevaviour of kexec for hardware error 
> +*/

Odd trailing comment on the next line.


