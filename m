Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2KLOC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:02:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2KLOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:02:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 48/55] ARC: [plat-arfpga] BVCI Latency Unit setup
Date: Mon, 12 Nov 2012 14:02:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-18-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-18-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121402.45019.arnd@arndb.de>
X-Provags-ID: V02:K0:GF8uNQsbkL0Au95ZUOUOm7btbMYW3YRGXYZg+FIelYT
 8+noD7t9UnGpgHRdtUJ7ixRXr3WMm8hRHRgITshreg7BW0a7oy
 9C3eDut8tP28HFVZQiumEVlG509U9Ra/tWyb7+pLTrxjjjnrrC
 vF+bV+fctYVBBOylWsPz7b0GgxrkbnyKDA+lxfEqk3VDNcFbki
 hUJ0Or4CresH3AMTdtvFfwYtHxCUt7a4L1h3h+4Xk8tJPJjgak
 +iTWU1T5Zpbq4sPZG8F1XzOie8+3brybTMa9jG6qgiCz4cSeT0
 KqG48mZa6xnzm1A7ncY0mp/eOD20zrA9b1xLMJG58oTWl6y7nY
 eT9IMs5cuT92pIXRXZOw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +       /* TBD: rewrite this using I/O macros */
> +       volatile unsigned int *base = (unsigned int *)BVCI_LAT_UNIT_BASE;
> +       volatile unsigned int *lat_unit = (unsigned int *)base + 21;
> +       volatile unsigned int *lat_val = (unsigned int *)base + 22;

Yes, you should do as the comment says.

	Arnd
