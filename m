Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1A1IAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:00:10 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:7997 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab1A1IAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:00:07 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOYEQk1XQJs4/2dsb2JhbACkf3S7JYVPBI9q
Message-ID: <4D427763.7080301@computer.org>
Date: Fri, 28 Jan 2011 08:59:31 +0100
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125144905.GC27510@htj.dyndns.org>
In-Reply-To: <20110125144905.GC27510@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/11 15:49, Tejun Heo wrote:
> I'm afraid this is gonna be something which works sometimes (or even
> more times than not) but can't ever be made reliable.  I think it
> would be better to head toward usb or other kind of early console.

Apologies in advance if this is a stupid idea, but would it be possible 
and safer to dedicate a whole device (such as a USB thumb drive or a 
memory card) to this? You could initialise the media in a certain way to 
let the kernel know that it is OK to trample on the device.

You'd have a mkpoops command (make persistent oops :-). Perhaps this 
could be a new partition table type. The kernel could either auto-detect 
such a device or be told which-one to use. It could then, upon crash and 
prior to writing to it, re-verify that the device bears the hallmarks of 
being a poops device.

Thanks, Jan
