Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1FPOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:49:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40170 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758393Ab1FPOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:49:48 -0400
X-Sasl-enc: 8NAWP5B9RFGtbNGe8sKhcKhvvxF61d6Y3/N+gv+xnj+U 1308235787
Date: Thu, 16 Jun 2011 07:34:59 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH v2] pch_phub: Don't oops if dmi_get_system_info
 returns NULL
Message-ID: <20110616143459.GA28928@kroah.com>
References: <1306910669-19348-1-git-send-email-alexander.stein@systec-electronic.com>
 <1308207924-14181-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308207924-14181-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:05:24AM +0200, Alexander Stein wrote:
> If dmi_get_system_info() returns NULL, pch_phub_probe() will
> dereferencea a zero pointer.
> 
> This oops was observed on an Atom based board which has no BIOS, but
> a bootloder which doesn't privde DMI data.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
> Changes in v2:
> * Adjust summary
> * Commit message is more verbose
> 
>  drivers/misc/pch_phub.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
