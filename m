Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0GMJ1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:27:10 -0400
Received: from shutemov.name ([188.40.19.243]:37337 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab0GMJ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:27:08 -0400
Date: Tue, 13 Jul 2010 12:27:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building of tusb6010
Message-ID: <20100713092707.GA31562@shutemov.name>
References: <20100712224254.GA29115@shutemov.name>
 <4C3C2DB1.8020705@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C2DB1.8020705@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 01:11:13PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Kirill A. Shutemov wrote:
> 
> >   CC      drivers/usb/musb/tusb6010.o
> > drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'do'
> > drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'while'
> > drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'do'
> > drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'while'
> > make[2]: *** [drivers/usb/musb/tusb6010.o] Error 1
> > make[1]: *** [drivers/usb/musb] Error 2
> > make: *** [drivers] Error 2
> 
> > Empty musb_platform_save_context and musb_platform_restore_context
> > provided by musb_core.h.
> 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
>     Such patch has already been submitted by Felipe Balbi:
> 
> http://marc.info/?l=linux-usb&m=127832134917692

Oh, Ok. Sorry.

-- 
 Kirill A. Shutemov
