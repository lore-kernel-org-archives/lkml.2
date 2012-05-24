Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2EXRux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:50:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37586 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754055Ab2EXRuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:50:51 -0400
Message-ID: <1337881849.5070.32.camel@joe2Laptop>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper
 functions
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: T Makphaibulchoke <tmac@hp.com>, lethal@linux-sh.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kaloz@openwrt.org,
        matt.fleming@intel.com, lasse.collin@tukaani.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com
Date: Thu, 24 May 2012 10:50:49 -0700
In-Reply-To: <4FBE72C4.3040204@zytor.com>
References: <1337875436-27640-1-git-send-email-tmac@hp.com>
	 <1337880371.5070.24.camel@joe2Laptop> <4FBE6FF6.5090904@zytor.com>
	 <1337881229.5070.29.camel@joe2Laptop> <4FBE72C4.3040204@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 10:41 -0700, H. Peter Anvin wrote:
> On 05/24/2012 10:40 AM, Joe Perches wrote:
> > Many of these functions are only optimized in certain cases; if not
> > optimized in a particular case, a call to the library function will be
> > emitted.
> Right, what part of that don't you understand?

:)

Whether or not the many applies to __builtin_mem<foo>.
I believe not.

cheers,

