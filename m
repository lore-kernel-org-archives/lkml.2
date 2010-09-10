Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0IJFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:16:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45094 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0IJFQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mqCly9YIghGCjKfgNfCVRu1QoY0QxBU0xXwAr6MLkT4KAgr8+4e3YJAGsuqGxPxi9k
         SuPzgo8UQM+5Jm5FT5HfFZck/93TRec+O5UYHtZIYgwHS8tjLBbPiGUi1c3mz3HkNLTd
         R4xztXTpPwC3rcLKTLYyDt3Te46rORXUm4W8U=
Date: Thu, 9 Sep 2010 22:16:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 036/223]drivers/input/touchscreen/mk712.c Update broken
 web addresses.
Message-ID: <20100910051619.GA31128@core.coreip.homeip.net>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
 <1284071205-7756-6-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284071205-7756-6-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:26:36PM -0700, Justin P. Mattock wrote:
> Below you will find an Update to a broken web address.
> Please let me know if this needs to be changed.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/input/touchscreen/mk712.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
> index efd3aeb..76f373a 100644
> --- a/drivers/input/touchscreen/mk712.c
> +++ b/drivers/input/touchscreen/mk712.c
> @@ -17,7 +17,7 @@
>   * found in Gateway AOL Connected Touchpad computers.
>   *
>   * Documentation for ICS MK712 can be found at:
> - *	http://www.icst.com/pdf/mk712.pdf
> + * http://web.archive.org/web/*/http://www.icst.com/pdf/mk712.pdf	

Shouldn't it be

http://www.idt.com/products/getDoc.cfm?docID=18713923

?

-- 
Dmitry
