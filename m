Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2BPU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:26:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:42210 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2BPU0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:26:47 -0500
Message-ID: <1329423997.2892.20.camel@pasglop>
Subject: Re: [PATCH 15/21] powerpc: Use generic posix_types.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>
Date: Fri, 17 Feb 2012 07:26:37 +1100
In-Reply-To: <3399.1329399884@redhat.com>
References: <1328677745-20121-16-git-send-email-hpa@zytor.com>
	 <1328677745-20121-1-git-send-email-hpa@zytor.com>
	 <3399.1329399884@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 13:44 +0000, David Howells wrote:
> PowerPC exports __FD_SET() and co. to userspace under some circumstances,
> therefore this patch potentially breaks the userspace ABI.  Is this okay, Ben?

I don't know why we would need that in userspace, unless some tools I
don't know about exploit them (hint: there shouldn't be)

I'm happy to remove them and see if anybody complains.

Cheers,
Ben.


