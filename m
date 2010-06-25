Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0FYLkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:40:07 -0400
Received: from mail2.picochip.com ([82.111.145.34]:42856 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624Ab0FYLkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:40:05 -0400
Date: Fri, 25 Jun 2010 12:41:50 +0100
From: Jamie Iles <jamie.iles@picochip.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: allow cross compiling with DWARF support
Message-ID: <20100625114150.GE4510@wear.picochip.com>
References: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com>
 <4C249027.1060304@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C249027.1060304@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 25 Jun 2010 12:39:57 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 08:16:55PM +0900, Masami Hiramatsu wrote:
> Jamie Iles wrote:
> > The path to elfutils was previously hardcoded as /usr/include/elfutils
> > which does not work with cross compilers. If CROSS_COMPILE is set, try
> > to set an include path from GCC's sysroot if GCC was built with sysroot
> > support, if sysroot support isn't enabled, don't specify a path for
> > elfutils allowing the user to set it with EXTRA_CFLAGS.
> 
> Hmm, I'm not so sure about cross compiling. I just thought
> if there is no sysroot support, we should warn user instead of
> just failing to find elfutils.
Is that something that you really need to warn the user about? If they have a
compiler without sysroot support they can still cross compile using
EXTRA_CFLAGS and the warning would be needless. There isn't a real requirement
for sysroot here, just a path to the elfutils headers.

Jamie
