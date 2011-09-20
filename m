Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab1ITQjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:39:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1ITQjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:39:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Ypb5VE8RK9Yi1k/Jhc3VX8axZH7aSN8nc8f/xmlTHTgOiPDYTNwzE32VxlP3+al2i
	f2R6WX4B5Pyt6XRnrRdaw==
MIME-Version: 1.0
In-Reply-To: <1316514056.3891.2.camel@mattotaupa>
References: <1316514056.3891.2.camel@mattotaupa>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Sep 2011 10:39:18 -0600
Message-ID: <CAErSpo4FACymQXs1fuDwP87_1U2XLTxC=wKLEK2Q0scxhw7R+Q@mail.gmail.com>
Subject: Re: [PATCH v2] x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: x86@kernel.org, linux-pci@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 4:20 AM, Paul Menzel
<paulepanter@users.sourceforge.net> wrote:
> ...
>
> Using coreboot [1] with this board the problem does not exist but this quirk also does not affect it either. To be safe though the check is tightened to only take effect when the BIOS from American Megatrends is used.
>
>        15:13 < ruik> but coreboot does not need that
>        15:13 < ruik> because i have there only one root bus
>        15:13 < ruik> the audio is behind a bridge

I'd like to know more about this coreboot situation.  Would it be
possible to get a dmesg log from the system with coreboot?  I'd like
to see how coreboot configures this device differently.

> CC: stable@kernel.org (≥ 2.6.34)
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: x86@kernel.org
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

This is fine with me.  I don't think it's the final solution, but I
think it's worth doing for now.

Bjorn
