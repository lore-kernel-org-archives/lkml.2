Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0DKRvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:51:32 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62803 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0DKRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mX+CxVL+6YIrhZ1bF3DPse0zUZ9EXRRibQsScOUDvwtTIWX0zRhGRsAalQXB5ZauDN
         5RF6QhbBQH9psbHBeNANk6mAX3GU/CQLwcpGj3yWpaY0rM5INSGrBuTMUR5uFcd2R6ls
         mAgMAeHYvZNihBnTAZMqEhAr0GnWIXjlOe8XM=
Date: Mon, 12 Apr 2010 21:51:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: LOCALVERSION_AUTO considered harmful
Message-ID: <20100412185136.GA13171@x200>
References: <20100411164701.GA7558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100411164701.GA7558@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 06:47:01PM +0200, Pavel Machek wrote:
> @@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
>  	  appended after any matching localversion* files, and after the value
>  	  set in CONFIG_LOCALVERSION.
>  
> +	  Unfortunately, such finegrained versioning will mean that you will
> +	  not be able to use modules for development; even "make modules"
> +	  will change module versions, making recompiled modules impossible
> +	  to insert into old kernel. 

That's conditional BS.
Turn off CONFIG_MODVERSIONS already.
