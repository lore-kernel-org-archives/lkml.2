Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1EYLKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:10:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1EYLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:10:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical Address Extensions
Date: Wed, 25 May 2011 13:10:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, David Brown <davidb@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com> <8yapqn7fyab.fsf@huya.qualcomm.com> <alpine.LFD.2.00.1105242042340.3207@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1105242042340.3207@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251310.39609.arnd@arndb.de>
X-Provags-ID: V02:K0:NU18tFdLP3yV3R/u+SzWvtuR9qHYB45BtG161qJsjJj
 /O/KiOqn2dmTFGV7qTCP/y4Gxw9eC76/64i+tKH5gRGURPpqT6
 ekc3qluJhF1dCFqp/OfkM+0n8dUTR7jNCbCvV2OpyiYl5gRtuj
 wKG8+4zFVHOU4WyMZv6jOXNW98vTo9mEQld0YwTTrZQYkTNsWL
 yshs6g61QAhjury4HXZ6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011, Nicolas Pitre wrote:
> > Do you expect non LPAE targets to be able to boot with these changes
> > applied (and LPAE enabled)?  I am able to build this tree for the
> > MSM8660 (with a minor patch below), but it fails to boot with LPAE
> > enabled.  It seems to work fine with LPAE not enabled.
> 
> I wouldn't expect a LPAE kernel to boot on non LPAE capable hardware.
> 
> And I don't think we'll ever try to support both LPAE and non-LPAE modes 
> in the same kernel binary either since this has implications all over 
> the place in core kernel mm code.

Just for information and to complete the picture, what other of these
combinations are possible?

* Non-LPAE kernel on LPAE-capable hardware

* LPAE kernel as KVM guest of LPAE kernel

* non-LPAE kernel as KVM guest of LPAE kernel

* LPAE kernel as KVM guest of non-LPAE kernel

* non-LPAE kernel as KVM guest of non-LPAE kernel on LPAE-enabled hardware

	Arnd
