Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0HMWZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:25:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0HMWZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:25:51 -0400
Message-ID: <4C65C630.4070008@zytor.com>
Date: Fri, 13 Aug 2010 15:24:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH][EFI] Run EFI in physical mode
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
In-Reply-To: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 12:18 PM, Takao Indoh wrote:
> 
> Basically EFI is in physical mode at first and it's switched to virtual
> mode after calling SetVirtualAddressMap. By applying this patch, you can
> run EFI always in physical mode. And you can also specify "virtefi" as
> kernel boot parameter to run EFI in virtual mode as before. Note that
> this patch supports only x86_64.
> 

Any hope to get a followon patch for i386 as well?  That would make it
largely a no-brainer.

Tony, does this affect ia64 in any way?

	-hpa
