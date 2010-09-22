Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0IVWui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:50:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab0IVWue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:50:34 -0400
Message-ID: <4C9A881B.9010309@zytor.com>
Date: Wed, 22 Sep 2010 15:50:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221220.34066.bjorn.helgaas@hp.com> <4C9A4AAF.3030503@zytor.com> <201009221253.01049.bjorn.helgaas@hp.com> <4C9A51DC.5020009@zytor.com> <alpine.DEB.2.00.1009221541350.22070@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1009221541350.22070@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 03:46 PM, David Rientjes wrote:
> On Wed, 22 Sep 2010, H. Peter Anvin wrote:
> 
>>> It's true, they don't (well, everything below 4G still lines up, but
>>> not above that).  Do you like this any better?
>>>
>>
>> That's fine with me.  I don't mind the [mem ] bracket either if you
>> think it's useful.
>>
> 
> This patch is going to break our userspace parsing scripts if you change 
> the output format.  Admittedly, we're probably one of the few users who 
> actually parses this output, but we do have reasons to do it for our 
> firmware.  If there was some improvement being introduced here, we'd 
> happily handle multiple regexs (we constantly add new patterns when new 
> kernels are released), but I'm not seeing how this is better.

Kernel messages are not an ABI or API.

The user space API for this stuff is /sys/firmware/memmap.

	-hpa
