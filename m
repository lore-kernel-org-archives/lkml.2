Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0LMIR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:17:26 -0500
Received: from www.tglx.de ([62.245.132.106]:36476 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0LMIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:17:25 -0500
Date: Mon, 13 Dec 2010 09:17:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2 1/4] genirq: Introduce driver-readable IRQ status
 word
In-Reply-To: <4D0543EE.7010007@web.de>
Message-ID: <alpine.LFD.2.00.1012130916140.2653@localhost6.localdomain6>
References: <cover.1292152963.git.jan.kiszka@web.de> <0b28922dfb7f5791fcb1866a0f1c033bacb8f4d8.1292152963.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012121747000.2653@localhost6.localdomain6> <4D0543EE.7010007@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010, Jan Kiszka wrote:
> Am 12.12.2010 18:29, Thomas Gleixner wrote:
> > Also we should name it different than status, drv_status perhaps, to
> > avoid confusion with the irq_desc status.
> 
> OK, will address both in a succeeding round (just waiting for potential
> further comments).

No further comments from my side ATM.

Thanks,

	tglx
