Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0FDGxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:53:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63427 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0FDGxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pSKFn/3hWvoy6s+ZYT0uao3pVA9f9zGAefjoifnDipNNjKLMXbjo+pTyVgnbLhX8iS
         2Ssb5RanWFBAtyr+w/EEc+g+b9V7G0WQXZW5alRy4MH6v4BY2TvSN+bLZcsBvC5WbQRw
         RvZZUp+0l07O6pDi1o2DXl6A9tQnJ4l/8v4u0=
MIME-Version: 1.0
In-Reply-To: <1275487340.3068.74.camel@localhost.localdomain>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	<AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	<AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	<1275420536.28134.37.camel@localhost.localdomain>
	<4C060224.4090601@nokia.com>
	<AANLkTikuXjWTEfYG2JLNW6znGGKNxzobw3ijCpG7u1xz@mail.gmail.com>
	<4C062092.2030608@nokia.com>
	<1275487340.3068.74.camel@localhost.localdomain>
Date: Fri, 4 Jun 2010 11:53:06 +0500
Message-ID: <AANLkTinIVaTocIgStpwKlXDByS7Z9t_OxJDYg0DoUMIN@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, verifying one file containing the hashes would be faster than
> verifying individual hashes stored as extended attributes (xattrs), but
> this does not take into account that files on a running system are being
> modified or added. On a small form factor, the number of files is
> limited, but would this scale well? In addition, what protects that one
> file containing all the hashes from being modified?  So, if you limit

How about sealing to protect this file?

> the types of files to those that don't change, and the number of file
> hashes, then using a single file would be faster.



-- 
Shaz
