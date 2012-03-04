Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2CDA1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:27:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53151 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab2CDA1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:27:53 -0500
Message-ID: <4F52B6F0.6060902@zytor.com>
Date: Sat, 03 Mar 2012 16:27:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: mingo@redhat.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        stable@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32
 oops
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org> <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org> <86zkbxusu2.fsf@sumi.keithp.com>
In-Reply-To: <86zkbxusu2.fsf@sumi.keithp.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 04:12 PM, Keith Packard wrote:
> <#part sign=pgpmime>
> On Wed, 22 Feb 2012 17:16:49 -0800, tip-bot for Matt Fleming <matt.fleming@intel.com> wrote:
> 
>> x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32 oops
> 
> This seems no different from the old fix -- I get 'Loading ...' and then
> a nice black screen on my MacBook Air.
> 

Do you have the dmesg from your MBA?  I'm wondering what the memory map
looks like...

	-hpa

