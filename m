Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab2FADkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:40:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60794 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758887Ab2FADkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:40:04 -0400
Message-ID: <4FC83940.9010708@zytor.com>
Date: Thu, 31 May 2012 20:38:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
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
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120528070336.GM3377@game.jcrosoft.org> <4FC82D89.1040108@hp.com>
In-Reply-To: <4FC82D89.1040108@hp.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 07:48 PM, Thavatchai Makphaibulcboke wrote:
> On 05/28/2012 01:03 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
>> can we do not duplicate those functions?
>>
>> Best Regards,
>> J.
> 
> Thanks J for the comment.  Unfortunately, there is no easy way to share
> files among different architectures' preboot environment.  We have the
> choices either to have each architecture define its own copies or the
> decompressor defines them.  I believe the former is preferable.  As
> Lasse also pointed out, this way any specific architecture could provide
> an architectural dependent optimized version, if it chooses to.
> 

We could always make a source code library, like we already in effect
have for the compression functions themselves.

	-hpa

