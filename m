Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2EXR0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:26:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38600 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753741Ab2EXR0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:26:13 -0400
Message-ID: <1337880371.5070.24.camel@joe2Laptop>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper
 functions
From: Joe Perches <joe@perches.com>
To: T Makphaibulchoke <tmac@hp.com>
Cc: lethal@linux-sh.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, matt.fleming@intel.com,
        lasse.collin@tukaani.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux@arm.linux.org.uk,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com
Date: Thu, 24 May 2012 10:26:11 -0700
In-Reply-To: <1337875436-27640-1-git-send-email-tmac@hp.com>
References: <1337875436-27640-1-git-send-email-tmac@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 10:03 -0600, T Makphaibulchoke wrote:
> The patch cleans up the file lib/decompress_unxz.c by removing all memory
> helper functions, e.g., memmove.  By doing so, any architecture's preboot
> environment supporting the XZ decompression needs to define its own copy of
> any of the missing memory helper functions.

Perhaps a silly question, but why not use
the __builtin variants?


