Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab2KBXhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:37:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35931 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab2KBXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:37:21 -0400
Date: Fri, 2 Nov 2012 16:37:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: drivres/hv
Message-ID: <20121102233717.GB3239@kroah.com>
References: <1351894283-12902-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351894283-12902-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:11:23PM -0700, K. Y. Srinivasan wrote:
>  
> Greg,
> 
> Recently, I had  re-sent a few patches. You have applied all the patches except the balloon driver
> related patches. Should I resend the balloon driver  patches. Let me know.

I can't apply the balloon driver until you get an ack from the
maintainers of the code you were exporting the symbols from.

Get that, and then resend them, as they are long gone from my "to-apply"
queue.

thanks,

greg k-h
