Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab0FDPJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:09:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50498 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0FDPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:09:44 -0400
Subject: Re: [PATCH 00/14] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Shaz <shazalive@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
       James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
In-Reply-To: <AANLkTinIVaTocIgStpwKlXDByS7Z9t_OxJDYg0DoUMIN@mail.gmail.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	 <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	 <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	 <1275420536.28134.37.camel@localhost.localdomain>
	 <4C060224.4090601@nokia.com>
	 <AANLkTikuXjWTEfYG2JLNW6znGGKNxzobw3ijCpG7u1xz@mail.gmail.com>
	 <4C062092.2030608@nokia.com>
	 <1275487340.3068.74.camel@localhost.localdomain>
	 <AANLkTinIVaTocIgStpwKlXDByS7Z9t_OxJDYg0DoUMIN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 11:09:18 -0400
Message-ID: <1275664158.3205.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 11:53 +0500, Shaz wrote:
> > Yes, verifying one file containing the hashes would be faster than
> > verifying individual hashes stored as extended attributes (xattrs), but
> > this does not take into account that files on a running system are being
> > modified or added. On a small form factor, the number of files is
> > limited, but would this scale well? In addition, what protects that one
> > file containing all the hashes from being modified?  So, if you limit
> 
> How about sealing to protect this file?

Was just indicating that the file needs to be protected. So, yes sealing
the file, based on PCRs, would work in a trusted boot environment.

> > the types of files to those that don't change, and the number of file
> > hashes, then using a single file would be faster.

Mimi


