Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2HQHnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:43:15 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35133 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2HQHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:43:14 -0400
Date: Fri, 17 Aug 2012 03:42:55 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <149466798.1924273.1345189375081.JavaMail.root@redhat.com>
In-Reply-To: <502D666A.9080906@linux.intel.com>
Subject: Re: x86, nops settings result in kernel crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.27.4]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On 08/16/2012 11:53 AM, Alan Cox wrote:
> >>
> >> Yes, if I remove the break statement (introduced by this commit),
> >> it works fine.
> > 
> > What version of qemu is this - do we have qemu bug here I wonder.
> > 
> 
> Also, is it 32 or 64 bits?

It's 64-bit.

Regards,

Tomas

> 
> 	-hpa
> 
