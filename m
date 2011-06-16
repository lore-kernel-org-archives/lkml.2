Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1FPJX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:23:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab1FPJXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:23:55 -0400
Date: Thu, 16 Jun 2011 11:23:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND/PATCH 0/2] trivial patches
In-Reply-To: <20110615130724.GN471@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.LNX.2.00.1106161122570.22872@pobox.suse.cz>
References: <1305589270-5389-1-git-send-email-balbi@ti.com> <20110615130724.GN471@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Felipe Balbi wrote:

> > following patches avoid double semicolons at the end
> > of module_init/module_exit calls.
> > 
> > Felipe Balbi (2):
> >   trivial: add missing ; at the end of module_init/module_exit
> >   init: drop trailing semicolon from module_init/module_exit
> 
> ping... ACK ? NAK ?

I got some conflicts/rejects when applying it right away, so it's now 
sitting in my queue with postponed low-priority patches.

If you'd be able to rebase it on current Linus' tree, it'll help.

Thanks,

-- 
Jiri Kosina
SUSE Labs
