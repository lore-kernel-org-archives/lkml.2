Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2JVT4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:56:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:52059 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2JVT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:56:09 -0400
Date: Mon, 22 Oct 2012 12:56:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [GIT PULL] extcon fixes for Linux 3.7
Message-ID: <20121022195606.GA13640@kroah.com>
References: <1350878680-12164-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350878680-12164-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 01:04:40PM +0900, MyungJoo Ham wrote:
> Hello Greg,
> 
> 
> The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:
> 
>   Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next

This isn't a signed-tag to pull from, it looks just like a branch
instead.  Is it really a signed tag?  If so, it sure didn't work like
one.

> Axel Lin (4):
>       extcon: adc-jack: Fix checking return value of request_any_context_irq
>       extcon: adc-jack: Add missing MODULE_LICENSE
>       extcon: Fix kerneldoc for extcon_set_cable_state and extcon_set_cable_state_
>       extcon: max77693: Use max77693_update_reg for rmw operations
> 
> Chanwoo Choi (1):
>       extcon: MAX77693: Add platform data for MUIC device to initialize registers
> 
> Devendra Naga (1):
>       extcon-max8997: remove usage of ret in max8997_muic_handle_charger_type_detach
> 
> Jenny TC (1):
>       extcon : register for cable interest by cable name
> 
> Peter Huewe (2):
>       extcon: Unregister compat class at module unload to fix oops
>       extcon: unregister compat link on cleanup
> 
> Sachin Kamat (2):
>       extcon: Remove duplicate inclusion of extcon.h header file
>       extcon: Fix return value in extcon_register_interest()
> 
> anish kumar (5):
>       extcon: standard cable names definition and declaration changed
>       extcon: optimising the check_mutually_exclusive function
>       extcon: checkpatch warning removal

Why is a checkpatch cleanup for 3.7?  Shouldn't that wait for 3.8?

Care to redo this?

thanks,

greg k-h
