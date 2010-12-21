Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0LUHKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:10:50 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34821 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0LUHKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:10:49 -0500
Date: Tue, 21 Dec 2010 08:10:39 +0100
From: Stephen Kitt <steve@sk2.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [Bug #24392] AGP aperture disabled, worked in 2.6.35
Message-ID: <20101221071039.GH7647@sk2.org>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
 <xqq2Z3iR9HJ.A.cHG.-0fDNB@chimera>
 <201012201214.57068.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012201214.57068.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 12:14:56PM -0700, Bjorn Helgaas wrote:
> That's kind of ugly because it's an exception to the normal "call
> pci_enable_device() first" rule, and it leads to bogus "conflicts"
> like this:
> 
>   pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
> 
> but I think we're stuck with it for now, and the simplest solution
> is to just revert 96576a9e1a.

I'm guessing
http://git.kernel.org/linus/46cfc58a77de5fc8385ad87077f4dc14633e57a7
should also be reverted then...

Regards,

Stephen
