Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2DCJNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:13:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2DCJN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120402235412.GD16303@tassilo.jf.intel.com>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
	<20120402235412.GD16303@tassilo.jf.intel.com>
Date: Tue, 3 Apr 2012 11:13:28 +0200
Message-ID: <CADDKRnAvJn8QKdRVVc_NpHD0jaiA_XzTOMeTm5DwrCJb-SR+kA@mail.gmail.com>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes , its really that commit!
My current top of source tree is:

jojo@eiche:/data/kernel/linux$ git log --pretty=oneline
3a5307cb7c25047242cf01c7698f25600f60b32e Revert "ACPI: Make ACPI
interrupt threaded"
dd775ae2549217d3ae09363e3edb305d0fa19928 Linux 3.4-rc1
b7ffff4bb3fef527a26144a95d9dfe8c11a6b927 Merge branch 's3-for-3.4' of
git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio-console
8bb1f229527dee95644e0f8496980bb767c6f620 Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
f22e08a79f3765fecf060b225a46931c94fb0a92 Merge branch
'sched-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
f187e9fd68577cdd5f914659b6f7f11124e40485 Merge branch
'perf-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
adb3b1f3fc1c6edb501808ebf80a81e81c52eb73 Merge tag 'parisc-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6
a75ee6ecd411a50bf4da927c2fdb2cb56246a2bd Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6


Am 3. April 2012 01:54 schrieb Andi Kleen <ak@linux.intel.com>:
>>  ACPI: Added _OSI(Processor Aggregator Device)
>>  ACPI: EC: EC description table is found, configuring boot EC
>>
>> Comparing this with the displays of kernel v3.3 the next expected
>> outputs would be:
>>
>>  ACPI: Interpreter enabled
>>  ACPI: (supports S0 S5)
>>
>>
>> I bisected the problem to commit:
>> 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d  "ACPI: Make ACPI interrupt threaded"
>
> Hmm, that's odd. It should not really change any semantics. I assume you double
> checked you hit the right commit?
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
