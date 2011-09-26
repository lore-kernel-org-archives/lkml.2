Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1IZSax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:30:53 -0400
Received: from lo.gmane.org ([80.91.229.12]:36954 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1IZSaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:30:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 8/26]   x86: analyze instruction and determine fixups.
Date: Mon, 26 Sep 2011 18:30:36 +0000 (UTC)
Message-ID: <loom.20110926T174216-443@post.gmane.org>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120127.25326.71509.sendpatchset@srdronam.in.ibm.com> <20110920171310.GC27959@stefanha-thinkpad.localdomain> <20110920181225.GA5149@infradead.org> <20110920205317.GA1508@stefanha-thinkpad.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 92.254.121.210 (Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20100101 Firefox/7.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Hajnoczi <stefanha <at> linux.vnet.ibm.com> writes:
> On Tue, Sep 20, 2011 at 02:12:25PM -0400, Christoph Hellwig wrote:
> > Do we now have sdt.h support for uprobes?  That's one of the killer
> > features that always seemed to get postponed.
> 
> Not yet but it's a question of doing roughly what SystemTap does to
> parse the appropriate ELF sections and then putting those probes into
> uprobes.

GDB now also implements this:
http://sourceware.org/ml/gdb-patches/2011-04/msg00036.html

Roland also posted a simple C based parser when he first suggested
the new format:
http://www.sourceware.org/ml/systemtap/2010-q3/msg00145.html

There is a complete description of the elf note section, argument format
and semaphore handling at:
http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

Cheers,

Mark

