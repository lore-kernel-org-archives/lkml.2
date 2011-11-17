Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1KQSIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:08:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab1KQSID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:08:03 -0500
Date: Thu, 17 Nov 2011 09:52:10 -0800
From: Greg KH <gregkh@suse.de>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] drivers/base/node.c: fix compilation error
Message-ID: <20111117175210.GE13208@suse.de>
References: <4EC4DD20.6080201@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC4DD20.6080201@evidence.eu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:08:32AM +0100, Claudio Scordino wrote:
> Hi all,
> 
> 	the current mainline kernel gives a "directives may not be used
> inside a macro argument" error message when compiled for the
> cris architecture.

Is this because cris is using an older version of gcc, or is it due to
something else?

Is this a recent problem, or one that has been around for a long time
(i.e. this fix should go to the -stable trees?)

thanks,

greg k-h
