Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1AQOsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:48:00 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:45479 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1AQOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:47:58 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 09:47:57 EST
Date: Mon, 17 Jan 2011 15:37:56 +0100
From: Bastian Blank <waldi@debian.org>
To: Steven Rostedt <rostedt@goodmis.org>, 609371@bugs.debian.org
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
Message-ID: <20110117143755.GA1119@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Steven Rostedt <rostedt@goodmis.org>, 609371@bugs.debian.org,
	David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
	ben@decadent.org.uk, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <4D3074FE.3030707@oldelvet.org.uk>
 <20110115.211722.39173519.davem@davemloft.net>
 <1295187469.22527.13.camel@duncow>
 <20110116.113944.48514452.davem@davemloft.net>
 <1295273486.16479.15.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295273486.16479.15.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:11:26AM -0500, Steven Rostedt wrote:
> The problem comes when the linker puts these sections together. We read
> all the sections as one big array. If the linker puts in holes, then
> this breaks the array, and the kernel crashes while reading the section.

I think this are still bugs in the linker script. #537862[1] was the
first occurance, but I don't find further information.

Bastian

[1]: http://bugs.debian.org/537862
-- 
What kind of love is that?  Not to be loved; never to have shown love.
		-- Commissioner Nancy Hedford, "Metamorphosis",
		   stardate 3219.8
