Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2FLRkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:40:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51651 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753860Ab2FLRkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:40:12 -0400
Message-ID: <1339522812.2404.4.camel@joe2Laptop>
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        T Makphaibulchoke <tmac@hp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Date: Tue, 12 Jun 2012 10:40:12 -0700
In-Reply-To: <4FD77CAF.1020402@zytor.com>
References: <1339470307-28223-1-git-send-email-tmac@hp.com>
	 <20120612191804.4211462a@tukaani.org>
	 <alpine.LFD.2.02.1206121316190.23555@xanadu.home>
	 <4FD77CAF.1020402@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 10:30 -0700, H. Peter Anvin wrote:
> On 06/12/2012 10:26 AM, Nicolas Pitre wrote:
> > 
> > Instead of copying, maybe this would be much better to make the content 
> > of lib/string.c usable in a pre-boot environment.

> Not sure about that... a lot of it is #ifndef __HAVE_ARCH_* and you
> *really* want those optimizations on some arches.

Can __weak be used?

