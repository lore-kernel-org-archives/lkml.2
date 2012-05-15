Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635Ab2EOQEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:04:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62395 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab2EOQED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:04:03 -0400
Date: Tue, 15 May 2012 12:03:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [34-longterm 179/179] x86/PCI: do not tie MSI MS-7253 use_crs
 quirk to BIOS version
Message-ID: <20120515160350.GB17760@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
 <1337048075-6132-180-git-send-email-paul.gortmaker@windriver.com>
 <20120515154455.39cfbad2@pyramind.ukuu.org.uk>
 <20120515154743.04879bde@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120515154743.04879bde@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 179/179] x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version] On 15/05/2012 (Tue 15:47) Alan Cox wrote:

> On Tue, 15 May 2012 15:44:55 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > O> MS-7253, for which we already have a quirk, but the short-sighted
> > > author tied the quirk to a single BIOS version, making it not kick in
> > 
> > It's our usual policy to tie to particular BIOS versions because these
> > things are often BIOS specific and come and go with updates.
> 
> Doh ignore that, the point is valid but not in a -longterm context

The prefix "34-longterm" isn't as clear as it was before we went to 3.0
so I'll change it to "2.6.34-stable" for next time.  We've stopped
separating longterm from stable on the server anyways.

Thanks,
Paul.

