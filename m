Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0HQKB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:01:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0HQKB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:01:27 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 12:01:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <1282016387.21419.113.camel@acb20005.ipt.aol.com> <201008171045.26155.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008171045.26155.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008171201.10142.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 11:45:25 Tvrtko Ursulin wrote:
> Why no timeouts? It sounds like a feasible way to work around listeners
> which have stopped working. (Timeout and -ETIME for example to be clear,
> not allowing access).

>From the kernel's point of view, there is no way to guess how long those 
timeouts should be.  Watching for progress can be implemented in user space 
though.

Setting errno to ETIME as a result of trying to access a file is likely to 
break some applications which are not prepared to receive this error 
condition; we cannot do that.

I'm quite sure that both of these issues have been discussed already.

Andreas
