Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2KLOKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:10:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2KLOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:10:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 52/55] ARC: Support for single cycle Close Coupled Mem (CCM)
Date: Mon, 12 Nov 2012 14:10:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-22-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-22-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121410.02682.arnd@arndb.de>
X-Provags-ID: V02:K0:7LbtWjCXqlQ79/O2+yZFz/w9COxp2ZHiwGMnbHOXxHY
 Nu21uCdX1/egFnS99QAkXxFuUgUVNj+9GCuV13PbvJDVFZR8UO
 UzHSdezD0EoT67s/n7PYkonds4ZaE3NGEDSw1zPeemQ+/amk2S
 OtmgzpTqdoMM+Mmg3yUocfOvQJCEeUjXRjzYrTfpHI7HsscVja
 EKBIQ35dPKNU6C39k42AOwSjfBZ94PycyHpZMF2tc05+/wH0PX
 ySv7g3LFUPDJLqKBpPaNHzSL2ieXHQAL4pBY02v1q3W5tWyFKS
 1yf2xa6iQ8R7mFVV8qrCbYb15EeL6986NFrM0AFsUugDqD7NUe
 k9PPqEH9w4i/ov1FKCtc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +config ARC_DCCM_SZ
> +       int "DCCM Size in KB"
> +       default "64"
> +       depends on ARC_HAS_DCCM
> +
> +config ARC_DCCM_BASE
> +       hex "DCCM map address"
> +       default "0xA0000000"
> +       depends on ARC_HAS_DCCM
> +

I suppose these should be configured from the device tree at boot time, not
during the build process.

I also wonder if the interface should be unified with what we use for
accessing the sram on some of the ARM platforms.

	Arnd
