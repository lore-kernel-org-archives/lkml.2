Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1DHPZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:25:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:50030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab1DHPZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:25:42 -0400
Date: Fri, 8 Apr 2011 08:26:25 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Marek <mmarek@suse.cz>, mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix up samsung-laptop.c duplication
Message-ID: <20110408152625.GA8053@suse.de>
References: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 05:02:02PM +0200, Michal Marek wrote:
> Hi,
> 
> The samsung-laptop.c driver got merged into drivers/platform/x86/, but a
> copy also stayed in drivers/staging and further fixes got applied there.
> A parallel build decides randomly which version to link into
> samsung-laptop.ko, so this cannot work even if it was intentional. This
> series applies the missing patches to drivers/platform/x86/ and deletes
> the old version.

Heh, yes, sorry about this, it was a miscommunication between me and
Matthew.

Matthew, do you want to take these patches in your tree, or do you want
me to send them to Linus?  Whatever is easier for you is fine with me.

thanks,

greg k-h
