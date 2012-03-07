Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab2CGSbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:31:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33866 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2CGSbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120305104538.GC18556@elte.hu>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	<86zkbxusu2.fsf@sumi.keithp.com>
	<4F52B6F0.6060902@zytor.com>
	<86wr71up4j.fsf@sumi.keithp.com>
	<20120305104538.GC18556@elte.hu>
Date: Wed, 7 Mar 2012 10:31:01 -0800
X-Google-Sender-Auth: 2D2d0ZmAOI15I0ypXRnP8YTsLg0
Message-ID: <CAE9FiQWFa=cBSHz=NkhhEbMriJqnhSpWwhwxjjyRLKVbMUme4A@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Keith Packard <keithp@keithp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, huang.ying.caritas@gmail.com,
        stable@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 2:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> ( Cc:-ed Yinghai - he can spot memory layout related bugs with
>  amazing efficiency. )
>
>  n/t
>
> * Keith Packard <keithp@keithp.com> wrote:
>
>> <#part sign=pgpmime>
>> On Sat, 03 Mar 2012 16:27:28 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>> > Do you have the dmesg from your MBA?  I'm wondering what the memory map
>> > looks like...
>>
>> Here's the first part of dmesg from a running kernel (3.3-rc1 plus some
>> DRM patches). Let me know if I cut this off too soon...

hi, Keith,

What is problem there? your system can not boot with latest kernel
when EFI is used?

Thanks

Yinghai
