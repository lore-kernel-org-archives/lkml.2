Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2EYHGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:06:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2EYHGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:06:46 -0400
Date: Fri, 25 May 2012 16:06:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: tty_lock lockdep warning
Message-ID: <20120525070638.GA16955@kroah.com>
References: <4FBF0DF9.5040806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF0DF9.5040806@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:43:37PM -0700, John Stultz wrote:
> Hey Alan,
> 	I've been seeing the following lockdep warning w/ Linus' 3.5-rc
> HEAD from today. This is running x86_64 in a kvm environment.
> 
> Let me know if there are any other details you'd like from me.

Known issue, see the thread with patches for it on lkml.  Any help with
those (in testing), is appreciated.

thanks,

greg k-h
