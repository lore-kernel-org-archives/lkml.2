Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2KBAOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:14:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40178 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2KBAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:14:31 -0400
Date: Thu, 1 Nov 2012 17:14:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stan Hu <stanhu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help with diagnosing kernel oops in __mutex_lock_slowpath
Message-ID: <20121102001429.GA2129@kroah.com>
References: <CAMBWrQ=Xrp-_opV0ej4rn20p3yTUP0TmYQHr5nG79szC0=WUDA@mail.gmail.com>
 <CAMBWrQm6CacSoUxZdNA9XPhDMqyAt2R15ZXxpCLEZcRvEeRiCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMBWrQm6CacSoUxZdNA9XPhDMqyAt2R15ZXxpCLEZcRvEeRiCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 03:02:45PM -0700, Stan Hu wrote:
> Hello,
> 
> I'm getting this kernel oops sporadically with a custom Cortex-A8 ARM
> board with a Linux 3.2.28 kernel.  The system is booting off an SD
> card; interestingly this failure doesn't seem to happen when I boot
> from NAND flash.   I would say 1 out 10 times it fails with a similar
> backtrace.  Does anyone have any clue why this might be happening?

Does this also happen on the 3.6 kernel, or 3.7-rc3?

thanks,

greg k-h
