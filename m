Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2DEPkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:40:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2DEPkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:40:09 -0400
Date: Thu, 5 Apr 2012 10:40:04 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Akio Idehara <zbe64533@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] toshiba_acpi: Add support for transflective LCD
Message-ID: <20120405154004.GB14821@thinkpad-t410>
Mail-Followup-To: Akio Idehara <zbe64533@gmail.com>, mjg59@srcf.ucam.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333551646-4575-1-git-send-email-zbe64533@gmail.com>
 <20120404183758.GA17327@thinkpad-t410>
 <4F7DAE00.6010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7DAE00.6010101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 11:36:48PM +0900, Akio Idehara wrote:
> >>  static const struct backlight_ops toshiba_backlight_data = {
> >> +	.options	= BL_CORE_SUSPENDRESUME,
> > 
> > What's the reason for adding this? I don't see that it's useful unless
> > we're handling BL_CORE_SUSPENDED, which toshiba_acpi is not doing.
> 
> 
> The reason is to restore transflective status, which is always disabled
> after resuming.  If BL_CORE_SUSPENDRESUME is added,
> set_lcd_state_status() is called from backlight_update_status() with
> stored brightness. So, when its brightness is 0, transflective status is
> enabled after resuming.

Okay, that makes sense.

Since you're in the neighborhood, would you mind fixing the whitespace
issues in the other fields of toshiba_backlight_data while you're at it?
Both get_brightness and update_status are indented using spaces rather
than a tab.

Thanks,
Seth

