Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2CHUaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:30:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56785 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2CHUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:30:00 -0500
Date: Thu, 8 Mar 2012 12:29:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] [IA64] hpsim, fix SAL handling in fw-emu
Message-ID: <20120308202955.GA11005@kroah.com>
References: <20120308195028.GA17564@kroah.com>
 <1331236879-20124-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331236879-20124-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 09:01:16PM +0100, Jiri Slaby wrote:
> The switch-cases of SAL_FREQ_BASE generate non-relocatable code. The
> same as for the ifs one level upper. This causes oopses early in boot
> because the kernel jumps to the hell instead of the offset in sal
> callback.
> 
> So use ifs here for SAL_FREQ_BASE decision too.
> 
> Isn't there any compiler directive or settings to solve that cleanly?
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

<snip>

Thanks for these, that works, I'll get back to applying the reset of
your series.

greg k-h
