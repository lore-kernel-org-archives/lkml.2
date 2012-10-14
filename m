Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2JNNIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 09:08:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33272 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2JNNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 09:08:01 -0400
Date: Sun, 14 Oct 2012 06:07:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: Staging: CSR: Fixed coding style warnings
Message-ID: <20121014130757.GA11575@kroah.com>
References: <n>
 <1350218909-20801-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350218909-20801-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 09:48:29PM +0900, Sangho Yi wrote:
> On drivers/staging/csr/csr_time.h, there were a few warnings on
> indentation, braces, and typedef struct usage.
> All those were changed to the proper way.

No, as I explained in the talk, only do one thing at a time here.

So, one patch for the indentation, one patch for the braces, and then,
one patch for the typedef.

And, with the typedef change, did you just break the build?  If not,
then the whole structure can be removed, right?

So, care to redo this?

thanks,

greg k-h
