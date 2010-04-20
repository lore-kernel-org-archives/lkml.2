Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0DTNWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:22:39 -0400
Received: from zmc.proxad.net ([212.27.53.206]:42373 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0DTNWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:22:37 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.224
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] globally ignore Module.symvers
Date: Tue, 20 Apr 2010 15:21:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-server; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004191642.52517.ffainelli@freebox.fr> <4BCDAA05.50506@suse.cz>
In-Reply-To: <4BCDAA05.50506@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004201521.46107.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010 15:20:05 Michal Marek wrote:
> On 19.4.2010 16:42, Florian Fainelli wrote:
> > If we build using make SUBDIRS=foo/ Kbuild will output per-directory
> > Module.symvers files that we do not want to keep track of. Ignore these
> > files globally.
> 
> SUBDIRS= or M= is meant for external modules, which generate their own
> Module.symvers. If you only need to build a part of the kernel sources,
> use 'make dir/'.

I was not aware of that, thank you Michal.
--
Florian
