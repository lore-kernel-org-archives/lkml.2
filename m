Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1K2V3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:29:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab1K2V3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:29:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
Date: Tue, 29 Nov 2011 21:29:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, linaro-dev@lists.linaro.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        android-virt@lists.cs.columbia.edu,
        embeddedxen-devel@lists.sourceforge.net
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111292129.20444.arnd@arndb.de>
X-Provags-ID: V02:K0:u8QXi2JlxcuqOLSfaWZ+jXEtmsCZnv6W8WiXa97XIrN
 GS4W96JSnre3lXtRwVYObxrtbNBFGmXUDzewzmiQ6uOCSQ5WEG
 hhDgac2sNSc7TraxHW9OWqAwjYnOLXNDM3297f8l1M8x8S9raI
 8yrQrO/yV+rVt+ancWLhk5qs+DEhTqABIivbtUD1wJzhP3Hw7y
 YPHRacWnLRAuUDwYXvy5/zK8NuyuQtjZMV08Qu497CyRBspg1X
 Gh42C/LABezAgATGy/H8MrD/TYb4tGOmGdd+baRQwssleHgLs1
 TXfI5wGfGxURcrLm3jwkNXCbsqwicE/2osBXzw1ZMHuyAfraIg
 KntVhSLyTHT6EBMiS/zg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 November 2011, Stefano Stabellini wrote:
> Hi all,
> a few weeks ago I (and a few others) started hacking on a
> proof-of-concept hypervisor port to Cortex-A15 which uses and requires
> ARMv7 virtualization extensions. The intention of this work was to find
> out how to best support ARM v7+ on Xen. See
> http://old-list-archives.xen.org/archives/html/xen-arm/2011-09/msg00013.html
> for more details. 
> 
> I am pleased to announce that significant progress has been made, and
> that we now have a nascent Xen port for Cortex-A15. The port is based on
> xen-unstable (HG CS 8d6edc3d26d2) and written from scratch exploiting
> the latest virtualization, LPAE, GIC and generic timer support in
> hardware.

Very nice!

Do you have a pointer to the kernel sources for the Linux guest?
Since Xen and KVM are both in an early working state right now,
it would be very nice if we could agree on the guest model to make
sure that it's always possible to run the same kernel in both
(and potentially other future) hypervisors without modifications.

	Arnd
