Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2GPLhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab2GPLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:37:03 -0400
Message-ID: <5003FCD2.80200@redhat.com>
Date: Mon, 16 Jul 2012 14:36:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos> <500118F1.8060300@web.de> <alpine.LFD.2.02.1207141253490.32033@ionos> <500156B3.6040205@web.de> <alpine.LFD.2.02.1207141402290.32033@ionos> <50016C44.5000607@web.de>
In-Reply-To: <50016C44.5000607@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2012 03:55 PM, Jan Kiszka wrote:

>>> The only way we can avoid that, is that we get a hint from the
>>> underlying irq chip/ handler setup with an extra flag to tell the
>>> core, that it's safe to avoid the ONESHOT/finalize magic.
>> 
>> So now it took a full month of ignorance to come up with the
>> mindboggling solution of working around the core change with a private
>> hack instead of sitting down and doing what was said to be the correct
>> solution.
> 
> We sat down and tried to avoid the core problem of our use case: IRQ
> threading. That we now have to fall back to something else is
> unfortunate and was surely not planned.
> 
> However, if you push your patch for 3.5, I'm sure Avi will happily drop
> the disliked workaround and replace it with ordinary IRQF_ONESHOT tagging.

Fine by me, of course, but is mucking around in the irq layer something
we want to do in -rc7?

-- 
error compiling committee.c: too many arguments to function


