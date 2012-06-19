Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2FSAB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:01:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53803 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FSABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:01:54 -0400
Date: Mon, 18 Jun 2012 17:01:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/rtl8192u: cleanup coding style problems
Message-ID: <20120619000150.GA4208@kroah.com>
References: <1339940861-18258-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339940861-18258-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 07:17:40PM +0530, Devendra Naga wrote:
> The following warnings / errors were cleaned
> 
> drivers/staging/rtl8192u/r8180_93cx6.c:25: ERROR: space required before the open parenthesis '('
> drivers/staging/rtl8192u/r8180_93cx6.c:28: ERROR: do not use C99 // comments
> drivers/staging/rtl8192u/r8180_93cx6.c:30: WARNING: line over 80 characters
> drivers/staging/rtl8192u/r8180_93cx6.c:31: ERROR: do not use C99 // comments
> drivers/staging/rtl8192u/r8180_93cx6.c:41: ERROR: space required after that ',' (ctx:VxV)
> drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: need consistent spacing a round '&' (ctx:WxO)
> drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: space prohibited after that '~' (ctx:OxW)
> drivers/staging/rtl8192u/r8180_93cx6.c:51: ERROR: space required after that ',' (ctx:VxV)
> drivers/staging/rtl8192u/r8180_93cx6.c:53: ERROR: space required before the open parenthesis '('
> drivers/staging/rtl8192u/r8180_93cx6.c:55: ERROR: space required after that ',' (ctx:VxV)
> drivers/staging/rtl8192u/r8180_93cx6.c:57: ERROR: space required after that ',' (ctx:VxV)
> drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: spaces required around that '=' (ctx:VxV)
> drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: space prohibited before that close parenthesis ')'
> drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: space required before the open parenthesis '('
> drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: trailing statements should be on next line
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

It's good you broke this down as to what you were fixing, but I don't
like this change:

> -	if(bit) return 1;
> -	return 0;
> +	return bit ? 1: 0;

Please don't use ? : if you can help it, it is just hard to read.

Care to redo this one and resend both patches?

thanks,

greg k-h
