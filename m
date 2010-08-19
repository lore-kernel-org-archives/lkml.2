Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0HSPDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:03:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39860 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0HSPDo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 19 Aug 2010 11:03:44 -0400
Date: Thu, 19 Aug 2010 11:02:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: nommu vm_get_page_prot and framebuffer drivers in 2.6.36-rc1
Message-ID: <20100819150245.GC9485@phenom.dumpdata.com>
References: <AANLkTi=VzruV3RYLTwKnC0bYtR7fSKzGehV=LLzoicXE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=VzruV3RYLTwKnC0bYtR7fSKzGehV=LLzoicXE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 03:21:35PM -0400, Mike Frysinger wrote:
> the recent commit c07fbfd17e614a76b194f371c5331e21e6cffb54 added a

Next time please do write to the folks that are on the Signed-off-by
list on the patch.

> call to vm_get_page_prot() in drivers/video/fbmem.c.  but this
> function doesnt exist for nommu.  so obviously we get:
> ERROR: "vm_get_page_prot" [drivers/video/fb.ko] undefined!

Duh!
> 
> looking a bit through mm/, i guess we should stub this out to 0 ?

Yes. Could you create a patch for this, please?

> #define vm_page_prot(x) 0
> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
