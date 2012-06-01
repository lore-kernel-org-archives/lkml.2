Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2FACyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:54:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37260 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758737Ab2FACyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:54:52 -0400
Message-ID: <1338519291.9151.7.camel@joe2Laptop>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper
 functions
From: Joe Perches <joe@perches.com>
To: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
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
Date: Thu, 31 May 2012 19:54:51 -0700
In-Reply-To: <4FC82D89.1040108@hp.com>
References: <1337875436-27640-1-git-send-email-tmac@hp.com>
	 <20120528070336.GM3377@game.jcrosoft.org> <4FC82D89.1040108@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 20:48 -0600, Thavatchai Makphaibulcboke wrote:
> On 05/28/2012 01:03 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > can we do not duplicate those functions?
> 
> Thanks J for the comment.  Unfortunately, there is no easy way to share
> files among different architectures' preboot environment.  We have the
> choices either to have each architecture define its own copies or the
> decompressor defines them.  I believe the former is preferable.  As
> Lasse also pointed out, this way any specific architecture could provide
> an architectural dependent optimized version, if it chooses to.

Maybe provide __weak default functions that
can be overridden by any arch that could
or wants to improve on the defaults.


