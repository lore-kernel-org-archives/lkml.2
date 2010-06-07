Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0FGRpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:45:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:48708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab0FGRpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:45:10 -0400
Date: Mon, 7 Jun 2010 10:43:50 -0700
From: Greg KH <gregkh@suse.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
Message-ID: <20100607174350.GA7807@suse.de>
References: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 12:57:12PM +0100, Ian Abbott wrote:
> From: Ian Abbott <abbotti@mev.co.uk>
> 
> The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
> made conditional on CONFIG_NET by commit
> f743ca5e10f4145e0b3e6d11b9b46171e16af7ce (applied in 2.6.18) to fix
> problems with undefined references in 2.6.16 when CONFIG_HOTPLUG=y &&
> !CONFIG_NET, but this restriction is no longer needed.

Why is this restriction no longer needed?  What changed?

> This patch makes the kernel/hotplug sysctl variable depend only on
> CONFIG_HOTPLUG.

Why is this needed?  Are you really running without a network and still
want to change the default /sbin/hotplug binary?

confused,

greg k-h
