Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0FAT3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:29:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46957 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab0FAT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:29:08 -0400
Subject: Re: [PATCH 00/14] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Shaz <shazalive@gmail.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
In-Reply-To: <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	 <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	 <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 15:28:56 -0400
Message-ID: <1275420536.28134.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 15:08 +0500, Shaz wrote:
> > EVM is based on EA while Aegis does not use EA as far as I can
> > understand from the documentation available. Can we make EVM
> > independent of EA? Even the MAC mechanism is very different then
> > existing LSM based mechanisms.
> 
> Have a look at the following:
> 
> http://research.nokia.com/files/NRCTR2008010.pdf
> http://research.nokia.com/files/NRCTR2008007.pdf
> http://lwn.net/Articles/372937/

SELinux, Smack, Capabilities, and IMA all use extended attributes. The
purpose of EVM is to detect offline tampering of these security extended
attributes.

The IMA integrity appraisal extension extends IMA with local measurement
appraisal. The extension stores and maintains the file integrity
measurement as an extended attribute 'security.ima', which EVM can be
configured to protect.  Instead of storing the hash measurement as an
extended attribute, the file hashes could be loaded in kernel memory, as
long as the appraise policy is appropriately constrained.

Mimi


