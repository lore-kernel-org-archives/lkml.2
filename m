Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2LNUPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:15:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2LNUPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:15:05 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update ucode on Intel's CPU
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 14 Dec 2012 12:10:27 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Message-ID: <1bdaf70f-7271-4aed-a985-0b455ccafab1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What info are you referring to?

Yinghai Lu <yinghai@kernel.org> wrote:

>On Fri, Dec 14, 2012 at 11:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> That patch doesn't apply on top of the merge of x86/mm2 and
>> linus/master.  A trivial fixup is totally nonfunctional -- no
>> earlyprintk, just a null pointer death in setup_real_mode().
>
>just saw linus pulled efi fix that is touching real_mode/init.c.
>and there is something wrong with it.
>
>will check that...
>
>>
>> I suspect we don't need init_level4_pgt at all and should just plan
>to
>> get rid of it.  Is there any reason we can't just build the proper
>> kernel page table set in pagetable_init() and switch to it there?
>
>then how to pass the info to AP?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
