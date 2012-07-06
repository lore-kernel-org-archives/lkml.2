Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2GFXIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:08:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45631 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2GFXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:08:39 -0400
Date: Fri, 6 Jul 2012 16:08:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Javier M. Mellid" <jmunhoz@igalia.com>
Cc: gewang@siliconmotion.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: sm7xxfb: erase hardcode cast between
 smtcfb_info and fb_info
Message-ID: <20120706230835.GA5936@kroah.com>
References: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
 <1340799015-3138-3-git-send-email-jmunhoz@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340799015-3138-3-git-send-email-jmunhoz@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 02:10:15PM +0200, Javier M. Mellid wrote:
> From: "Javier M. Mellid" <jmunhoz@igalia.com>
> 
> This patch erases hardcode cast between smtcfb_info and fb_info in order
> to get a more robust and less rigid smtcfb_info structure. fb_info
> doesn't need to be the first field in smtcfb_info after this patch.

Nice job, stuff like this is always appreciated.

greg k-h
