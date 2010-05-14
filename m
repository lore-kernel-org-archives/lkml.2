Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab0ENUvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:51:17 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:42384 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab0ENUvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XuM3CZWM6An/uvqEziJGXtofOlBKCArH9yUIJVQ1vG3birxpH+9fuiq6c29H+RwCQZ
         Yi7SFvB8iud9lpO6TSFRgJO4KJvg9N+6f4etsmLhzHjuqlWnA6k31gPW7dW1tTQfBiN3
         BlLxVFp6DtR+s1aDdL+EJG6IDc5+VKba/hdnM=
MIME-Version: 1.0
In-Reply-To: <4BED986D.1010403@zytor.com>
References: <20100501025423.GA10671@vana.vc.cvut.cz>
	 <4BED986D.1010403@zytor.com>
Date: Fri, 14 May 2010 13:51:13 -0700
X-Google-Sender-Auth: 3kbH9pQLkOs-vIfchBve42tT6TA
Message-ID: <AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
Subject: Re: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes in 
	PCIe space
From: Petr Vandrovec <petr@vandrovec.name>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dcovelli@vmware.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 11:37 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/30/2010 07:54 PM, Petr Vandrovec wrote:
>> Hello,
>>   openSUSE11.3 32bit kernels hang when installed to the VMware's VMs because Moorestown
>> fixed capabilities detection code enters endless loop on Intel's AGP bridges (with
>> device ID=7191).  See https://bugzilla.kernel.org/show_bug.cgi?id=15888 for additional
>> details.  arch/x86/pci/mrst.c was introduced after 2.6.33, so only 2.6.34-rcX are
>> affected.
>>                               Thanks,
>>                                       Petr Vandrovec

> Could you check if this patch fixes your problem, and if so let me know
> as soon as possible?
>
> Sorry for the delay.

Thanks for the fix.  Yes, it fixes hang too, and seems much nicer..

Petr
