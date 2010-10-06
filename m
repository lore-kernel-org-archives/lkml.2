Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0JFRb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:31:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41308 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0JFRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:31:27 -0400
Message-ID: <4CACB257.7060705@zytor.com>
Date: Wed, 06 Oct 2010 10:31:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/7] acpi: use indirect call to register gsi in different
 modes
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop> <1283167276-7364-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.00.1010061749110.2440@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1010061749110.2440@kaball-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 10:00 AM, Stefano Stabellini wrote:
> Peter,
> I sent this patch a while back as part of the "PV on HVM: receive
> interrupts as xen events" series (that it is based upon Konrad's
> pcifront series, he sent another version to the list yesterday).
> 
> Do you think that this is a reasonble approach?
> 
> If you want to give a look at the whole series you can find it here:
> 
> http://lkml.org/lkml/2010/8/30/170
> 
> everything else is Xen specific stuff.
> 
> Thanks in advance,
> 

On the surface it seems reasonable.

Thomas Gleixner has been working on greatly revamping a bunch of the x86
interrupt code, and this might interact with his stuff, so it would be
good if he could comment on it.

[tglx: what they're apparently working on is to redirect APIC interrupts
to Xen event channels so they don't have to interact with the simulated
memory-mapped APIC.  It's "paravirtualization light".]


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

