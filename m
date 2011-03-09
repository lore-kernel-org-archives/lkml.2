Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1CIRXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:23:30 -0500
Received: from codepoet.org ([166.70.99.138]:43720 "EHLO codepoet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1CIRX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:23:29 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Mar 2011 12:23:29 EST
Date: Wed, 9 Mar 2011 10:16:32 -0700
From: Erik Andersen <andersen@codepoet.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32.33
Message-ID: <20110309171632.GA18029@mail.codepoet.org>
Reply-To: andersen@codepoet.org
Mail-Followup-To: andersen@codepoet.org, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <20110307232404.GA24927@kroah.com>
 <20110307232416.GB24927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307232416.GB24927@kroah.com>
X-No-Junk-Mail: I do not want to get *any* junk mail.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Mar 07, 2011 at 03:24:16PM -0800, Greg KH wrote:
> diff --git a/Makefile b/Makefile
> index e734450..c3f6287 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 32
> -EXTRAVERSION = .31
> +EXTRAVERSION = .32

In the email subject, you meant to say "Linux 2.6.32.32"...

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
