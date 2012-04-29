Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2D2Pxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 11:53:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2D2Pxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 11:53:51 -0400
Date: Sun, 29 Apr 2012 08:53:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jens Gustedt <jens.gustedt@loria.fr>
Cc: Jens.Gustedt@inria.fr, linux-kernel@vger.kernel.org
Subject: Re: BUG in 3.3.4
Message-ID: <20120429155346.GA5399@kroah.com>
References: <iTWyS-35l-7@gated-at.bofh.it>
 <4F9D2A2B.9090501@loria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9D2A2B.9090501@loria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 01:46:51PM +0200, Jens Gustedt wrote:
> Hi,
> it looks that there is a regression in 3.3.4 compared to 3.3.3.
> 
> After migrating I have the BUG as copied below.
> 
> If somebody thinks that this would make sense, I could try to bisect this.

Yes, please run 'git bisect' to try to find the offending patch.

thanks,

greg k-h
