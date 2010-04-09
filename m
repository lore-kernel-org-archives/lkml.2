Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0DIUaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:30:46 -0400
Received: from tex.lwn.net ([70.33.254.29]:57529 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab0DIUap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:30:45 -0400
Date: Fri, 9 Apr 2010 14:30:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/16] viafb: Retain GEMODE reserved bits
Message-ID: <20100409143032.063407ae@bike.lwn.net>
In-Reply-To: <4BBF8CAA.3090506@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-5-git-send-email-corbet@lwn.net>
	<4BBE99F6.9060300@gmx.de>
	<20100409135959.381d819a@bike.lwn.net>
	<4BBF8CAA.3090506@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 22:23:06 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> > That had crossed my mind; there is quite a bit of duplicated code
> > between those two very long functions.  At the time I was focused on
> > making things work, and I didn't want to mess with code that I couldn't
> > actually test.  So further cleanup is on my list, but I would prefer to
> > defer it for a little bit.  
> 
> The code (and the spec regarding the reserved bits also) is obviously 
> identical so please don't ignore it.

In fact, I already came to this conclusion and have added a patch to
have both functions use the same code.

Thanks,

jon
