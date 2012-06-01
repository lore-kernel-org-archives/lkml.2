Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727Ab2FAS6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:58:17 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32061 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab2FAS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:58:15 -0400
Message-ID: <4FC910BB.7030908@hp.com>
Date: Fri, 01 Jun 2012 12:58:03 -0600
From: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "lasse.collin@tukaani.org" <lasse.collin@tukaani.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper functions
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120528070336.GM3377@game.jcrosoft.org> <4FC82D89.1040108@hp.com> <4FC83940.9010708@zytor.com> <4FC90C01.2060005@hp.com> <4FC90E00.7010100@zytor.com>
In-Reply-To: <4FC90E00.7010100@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 12:46 PM, H. Peter Anvin wrote:
> 
> Well, the decompression stuff is under lib/ ... maybe lib/boot/ or
> something like that...
> 
> 	-hpa
> 
> 

Thanks again for the comment.  I thought of putting it under arch to
separate it from the main line kernel to avoid any confusion.  But if
you think it is OK to put under lib/boot, that sounds good to me.

Thanks,
Mak.
