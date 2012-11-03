Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638Ab2KCBR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:17:28 -0400
Received: from edge.cmeerw.net ([84.200.12.152]:54715 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab2KCBR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:17:26 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 21:17:26 EDT
Date: Sat, 3 Nov 2012 02:10:31 +0100
From: Christof Meerwald <cmeerw@cmeerw.org>
To: Eric Wong <normalperson@yhbt.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, libc-alpha@sourceware.org,
        linux-api@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC/PATCH] epoll: replace EPOLL_CTL_DISABLE with EPOLL_CTL_POKE
Message-ID: <20121103011031.GA22452@edge.cmeerw.net>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
 <20121102041312.GA15886@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102041312.GA15886@dcvr.yhbt.net>
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012 04:13:12 +0000, Eric Wong wrote:
[...]
> EPOLL_CTL_POKE may be used to force an item into the epoll
> ready list.  Instead of disabling an item asynchronously
> via EPOLL_CTL_DISABLE, this forces the threads calling
> epoll_wait() to handle the item in its normal loop.

That was my initial suggestion as well - see
https://lkml.org/lkml/2012/6/19/358


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
