Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0IXVfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:35:30 -0400
Received: from xenotime.net ([72.52.115.56]:44158 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757293Ab0IXVf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:35:29 -0400
Date: Fri, 24 Sep 2010 14:35:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v5
Message-Id: <20100924143518.d475a039.rdunlap@xenotime.net>
In-Reply-To: <20100924213009.GF10777@lucy>
References: <20100921224610.GO13162@lucy>
	<20100923221253.GA4960@lucy>
	<20100923225346.GB4960@lucy>
	<201009241512.39311.arnd@arndb.de>
	<AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
	<20100924095625.5beedf5a.rdunlap@xenotime.net>
	<20100924210642.GE10777@lucy>
	<20100924142006.a79833ab.rdunlap@xenotime.net>
	<20100924213009.GF10777@lucy>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 14:30:09 -0700 Vernon Mauery wrote:

> >> +/* The RTL table as presented by the EBDA: */
> >> +struct ibm_rtl_table {
> >> +	char signature[5];
> >
> >Question:  are all 5 bytes of signature[] used?  It looks like the search code
> >only checks for 32 bits of signature (and the last byte can be garbage?).
> 
> Technically, the 5 bytes are supposed to be "_RTL_", but it is a lot 
> easier to just check _RTL since we can do that with a single read.  I 
> suppose I could do a 64-bit read and mask the bits that matter.  Do you 
> have an opinion on the matter?

I would just comment that the first 4 bytes are checked.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
