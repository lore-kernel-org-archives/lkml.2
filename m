Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab2AMScY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:32:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2AMScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:32:23 -0500
Date: Fri, 13 Jan 2012 10:31:20 -0800
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: lowmemorykiller: Don't wait more than
 one second for a process to die
Message-ID: <20120113183120.GB30990@suse.de>
References: <20120113182125.GA15495@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120113182125.GA15495@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:21:25PM +0400, Anton Vorontsov wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> If a process forked and the child process was killed by the
> lowmemorykiller, the lowmemory killer would be disabled until
> the parent process reaped the child or it died itself.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
> 
> Noticed that the patch is missing. Any reason for not wanting it
> in staging?

No, I must have missed this one, sorry about that.  Where was it that I
should have seen it?

I'll queue this up after 3.3-rc1 is out to get it into the final 3.3
release.

thanks,

greg k-h
