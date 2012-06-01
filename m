Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab2FACsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:48:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16819 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab2FACst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:48:49 -0400
Message-ID: <4FC82D89.1040108@hp.com>
Date: Thu, 31 May 2012 20:48:41 -0600
From: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
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
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120528070336.GM3377@game.jcrosoft.org>
In-Reply-To: <20120528070336.GM3377@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 01:03 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:

> can we do not duplicate those functions?
> 
> Best Regards,
> J.

Thanks J for the comment.  Unfortunately, there is no easy way to share
files among different architectures' preboot environment.  We have the
choices either to have each architecture define its own copies or the
decompressor defines them.  I believe the former is preferable.  As
Lasse also pointed out, this way any specific architecture could provide
an architectural dependent optimized version, if it chooses to.

Thanks,
Mak.
