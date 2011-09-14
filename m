Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1INNsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:48:35 -0400
Received: from void.printf.net ([89.145.121.20]:44189 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1INNse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:48:34 -0400
From: Chris Ball <cjb@laptop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Philip Rakity <prakity@marvell.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org>
	<4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org>
	<4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org>
	<D45CBF70-F0B1-453A-9E31-A621F52C21B9@marvell.com>
	<4E6FC422.9080306@goop.org>
	<7C3ED924-555D-4C50-9000-36077650328C@marvell.com>
	<4E6FCE28.5040403@goop.org>
	<F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com>
	<4E6FDA0B.9060007@goop.org> <4E6FDC3E.8030702@goop.org>
	<003A4041-99F9-4598-AB9A-D08C76CDAECB@marvell.com>
	<4E6FFADE.5090004@goop.org>
Date: Wed, 14 Sep 2011 09:48:21 -0400
In-Reply-To: <4E6FFADE.5090004@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 13 Sep 2011 17:52:46 -0700")
Message-ID: <m2k49b9qvu.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Tue, Sep 13 2011, Jeremy Fitzhardinge wrote:
> Very strange.  I reinstalled the original 2.6.38-based F15 kernel
> (kernel-2.6.38.6-26.rc1.fc15.x86_64) which I'm sure did work, and it is
> failing in the same way.  So I guess some BIOS setting changed, or the
> hardware itself has died?  But it's still there; it does appear on the
> PCI bus, and it does respond to the driver to some extent (register
> dumps aren't all 0xff, etc).

Long shot, but did you try removing power completely between the reboots?
I wonder if the PCI config space write patch could be (a) bogus for your
device, and (b) preserved across warm reboot by your PCI hardware.

So, you could just try removing the battery and PSU, hitting the power
button a few times with them unplugged to discharge caps, and then
boot into the old kernel again.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
