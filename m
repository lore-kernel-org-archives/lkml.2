Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1ISNmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:42:54 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:25523 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754176Ab1ISNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:42:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OraLG4IVM1nInvgMWNFU7Fp1ra0ruLGbJZrDu3q1MBZoAmW
 rnA0wXm_6NTDJxx6vieon1lFu2eXTGvyzuFTH6DxU.PFOULT6eGFBqEuK5vM
 6SFR_a6ZkD73ugTasQc7j8QViQviPZRZ143ZhqQsjlhRE5PXNqSk6VLEtjP7
 WG5q_0138pbM4A6oUyCmzd2ZITibKXg7VKJoyZANjx_pF4N5MvNSRY5NDsHZ
 E1iKd1JL5kYxiYNiaXnFqW0XfUIka3i.l3ep9QDnWHSD2BbWI8fnotmOGSdB
 ftjpywnvFtuyvzyHnpQ0C0OgLtqVWhHF3A0iv4.hnXgWFWWrp.iKPktlb7sU
 ruC6e3q8c39F0XyKlaEntH5RDC4qDDY.JMtPiC37dMHeBBIr8LyVpCPn7SQ3
 mHa561jfxwtofEYEGLtLTFlo-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 08:42:46 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Vasiliy Kulikov <segoon@openwall.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
In-Reply-To: <20110918170512.GA2351@albatros>
Message-ID: <alpine.DEB.2.00.1109190841580.8771@router.home>
References: <20110910164001.GA2342@albatros> <20110910164134.GA2442@albatros> <20110914192744.GC4529@outflux.net> <20110918170512.GA2351@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Sep 2011, Vasiliy Kulikov wrote:

> > Reviewed-by: Kees Cook <kees@ubuntu.com>
>
> Looks like the members of the previous slabinfo discussion don't object
> against the patch now and it got two other Reviewed-by responses.  Can
> you merge it as-is or should I probably convince someone else?

The patch is incomplete. If you want to restrict access to this
information then /sys/kernel/slab needs to have a similar
restriction.


