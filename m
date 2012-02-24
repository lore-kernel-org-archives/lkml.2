Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2BXCwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 21:52:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42299 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab2BXCwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:52:05 -0500
X-Sasl-enc: L7Vea3OsV6WOgJHVGoTTnqhc/E92sxmvwqU85FZPo8Hb 1330051923
Date: Thu, 23 Feb 2012 18:51:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Devin J. Pohly" <djpohly@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] mei: cosmetic cleanup in interrupt.c
Message-ID: <20120224025126.GA13685@kroah.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
 <1330047536-3827-2-git-send-email-djpohly@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330047536-3827-2-git-send-email-djpohly@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 08:38:48PM -0500, Devin J. Pohly wrote:
> From: "Devin J. Pohly" <djpohly@gmail.com>
> 
> Tabs, spaces, long lines, lines that could be combined, superfluous
> parentheses, etc.  Also uses DIV_ROUND_UP and sizeof(*ptr) where
> appropriate.

That's a lot of different things all in one patch.

Please only do one thing per patch.

Also, please cc: the maintainers of this patch, I'm sure they would also
have comments on it, use the scripts/get_maintainer.pl tool to figure
out who to send it to (hint, you also should copy the driverdevel
mailing list.)

Care to redo these please?

thanks,

greg k-h
