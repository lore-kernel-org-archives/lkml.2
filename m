Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1LHXHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:07:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59688 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1LHXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:15 -0500
X-Sasl-enc: VRJe/aiQsWgIKqTLM6A0EjTQo3vsJCeAjSyrjSvj651c 1323385634
Date: Thu, 8 Dec 2011 14:55:55 -0800
From: Greg KH <greg@kroah.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/3] staging: vtt6655: 80211hdr.h, 80211mgr.c: General
 cleanup
Message-ID: <20111208225555.GA22949@kroah.com>
References: <1322855714-6182-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322855714-6182-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 07:55:14PM +0000, Marcos Paulo de Souza wrote:
> This patch removes some useless comments, commented code and blank
> lines. Also fix coding style of headers of functions.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: devel@driverdev.osuosl.org
> ---
>  drivers/staging/vt6655/80211hdr.h |   14 --
>  drivers/staging/vt6655/80211mgr.c |  300 ++++++-------------------------------

Please split this up into one-patch-per-thing-you-do.

thanks,

greg k-h
