Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2KLOMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:12:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2KLOMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:12:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
Date: Mon, 12 Nov 2012 14:12:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jonas Bonn <jonas.bonn@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <CACM3HyHAKgJ2aTGjidZr5T9WFL3m+FTbUz_1QtO2gAgSFQm8fA@mail.gmail.com> <50A10091.6020606@synopsys.com>
In-Reply-To: <50A10091.6020606@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121412.47702.arnd@arndb.de>
X-Provags-ID: V02:K0:qZ5b94zLIM6Fu7devvrCEQ+nrGU+Bnjh6WfAMoGEsvD
 97rpBkGUxWTHop9qVsQLhGGUqoRQ0JnrdyPFI4hbP4zwhbluoq
 6l/5JcVV2wMxdE+S8Vd0bwnI0/MEmduPUsUbgAeTXSF0/JcgGo
 YZaQWuZjKSs3WiqTKstVyIr8kvpn1CnEEPDJiAFhKqOaDt7nqe
 WHWvdhboPM0wr4HrO4jarL5I22S80YGSkTylDSbUlCRz1DGtXj
 iP0MY2mAZHXmjhTc7W96Go1RTfLd2Nm44+eMeMV/0dzmYieSbx
 6VxUtMOvP+ym++x9cH6S1PQ9tJyBEBCZNuGeroiHwP0Hv7PYjC
 C5FD/UVNMDniszabaZtg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet Gupta wrote:
> But just to clarify, gdbserver will still use ARC specific
> ptrace(PEEKUSR) as opposed to regset interface. The switch to new gdb
> version is non trivial and I can't ask our active customers to go to
> some out-of-mainline tree until that gets fixed.

But your customers could use an out-of-tree kernel patch to put the
implementation of PEEKUSR back into their kernels, right?

Over time, they could just drop that patch once they move to a
newer gdb version.

	Arnd
