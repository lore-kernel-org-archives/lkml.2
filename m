Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0LMKTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:19:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934Ab0LMKTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:19:48 -0500
Message-ID: <4D05F337.3000701@redhat.com>
Date: Mon, 13 Dec 2010 12:19:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2 4/4] KVM: Allow host IRQ sharing for passed-through
 PCI 2.3 devices
References: <cover.1292152963.git.jan.kiszka@web.de> <5a8f3388ba70d018510fa75f42ef677ad0765e69.1292152963.git.jan.kiszka@web.de>
In-Reply-To: <5a8f3388ba70d018510fa75f42ef677ad0765e69.1292152963.git.jan.kiszka@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2010 01:22 PM, Jan Kiszka wrote:
> From: Jan Kiszka<jan.kiszka@siemens.com>
>
> PCI 2.3 allows to generically disable IRQ sources at device level. This
> enables us to share IRQs of such devices on the host side when passing
> them to a guest.
>
> However, IRQ disabling via the PCI config space is more costly than
> masking the line via disable_irq. Therefore we register the IRQ in adaptive
> mode and switch between line and device level disabling on demand.
>
> This feature is optional, user space has to request it explicitly as it
> also has to inform us about its view of PCI_COMMAND_INTX_DISABLE. That
> way, we can avoid unmasking the interrupt and signaling it if the guest
> masked it via the PCI config space.
>

Looks fine.

> +		ret =IRQ_NONE;
> +

Danger, whitespace error detected.  Initiating self-destruct sequence.

-- 
error compiling committee.c: too many arguments to function

