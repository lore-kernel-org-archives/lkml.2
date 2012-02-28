Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2B1C2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:28:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49806 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2B1C2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:28:10 -0500
Message-ID: <4F4C3BA2.1070708@kernel.org>
Date: Mon, 27 Feb 2012 18:27:46 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: matt.fleming@intel.com, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32
 oops
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org> <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org> <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com> <4F45B35D.1010702@zytor.com> <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com> <4F471651.3080609@zytor.com>
In-Reply-To: <4F471651.3080609@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 08:47 PM, H. Peter Anvin wrote:
>>
>> please check attach patch for tip/efi branch.
> 
> That doesn't do anything like what I noted above.
> 
> We should get rid of dependencies on legacy PC memory layouts, not add
> more hacks.  What is so hard about "when we create the initial mappings,
> only create for RAM/ACPI/EFI regions" (if we even need to do so for
> ACPI, I think ACPI might use ioremap() already)?
> 

Hi Yinghai,

Can you please answer my question?

	-hpa

