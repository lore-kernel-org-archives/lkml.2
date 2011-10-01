Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1JAHus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 03:50:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45317 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1JAHul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 03:50:41 -0400
Message-ID: <4E86C64C.8020408@gmail.com>
Date: Sat, 01 Oct 2011 09:50:36 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Shea Levy <shea@shealevy.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 10/10] x86, efi: EFI boot stub support
References: <1316607036-9235-1-git-send-email-matt@console-pimps.org>  <1317372688-15150-1-git-send-email-matt@console-pimps.org>  <4E85ED25.6060208@shealevy.com> <1317413508.3375.40.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1317413508.3375.40.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 09/30/2011 10:11 PM, Matt Fleming wrote:
> On Fri, 2011-09-30 at 12:24 -0400, Shea Levy wrote:
>> Hi Matt,
>>
>> I would like to test this patch series (My EFI systems are MBP 5,5, Asus 
>> p8p67 pro, and the VirtualBox EFI setup). Will you want to hear the 
>> results? If so, is there a specific procedure or set of things to test 
>> that you'll want to know about? Also, other than patch 10 should I use 
>> the v3 version of the patches sent to this list, or is there a better 
>> place to pull the patches from?
> Hi Shea,
>
> I'd definitely like to hear the results if you could try it out on your
> machines! There's no specific procedure to try, just try to break it ;-)
>
> You can find the patches at the top of the 'x86/efi-stub' branch at,
>
> 	https://github.com/mfleming/linux-2.6.git
>
Cute, I think you reintroduced the same bug in v4 with load_options_size ;)

Shouldn't it be /= 2 ?

Conditionally-signed-off-by-if-fixed-in-v5: Maarten Lankhorst <m.b.lankhorst@gmail.com>

Still would love to see ASCII support though :(

~Maarten
