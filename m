Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0JTVSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:18:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:45323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0JTVSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:18:20 -0400
Date: Wed, 20 Oct 2010 14:17:10 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Charkov <alchark@gmail.com>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: Add support for VIA VT8500 and compatibles in
 EHCI HCD
Message-ID: <20101020211710.GB10006@suse.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
 <1287608139-21354-4-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287608139-21354-4-git-send-email-alchark@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 12:55:36AM +0400, Alexey Charkov wrote:
> VIA and WonderMedia Systems-on-Chip feature a standard EHCI host
> controller. This adds necessary glue to use the standard driver
> with these systems.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> Please review and state whether this could be acceptable for a merge
> to mainline in the coming 2.6.37 window. If possible, I would deeply
> appreciate a merge to a relevant git tree for integration prior to
> asking Linus to pull the changes. I could rebase the code if needed,
> currently this is against Linus' master branch.
> 
> This patch relies on the basic architecture support for VT8500/WM8505
> to be in place, as introduced by PATCH 1/6 in this series.

Will this code fail to build without that patch?

thanks,

greg k-h
