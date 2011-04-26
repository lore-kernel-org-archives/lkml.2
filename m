Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1DZTFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:05:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1DZTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MxGAgRm5+Bnj4GH1ZyeNg+EcGys7aTDDoIqbcX0153XRRIC1WVBisuq6q95JfDQPv3
         1JMldARFTAr4l75RFy+n0OjoICTS2cr4DLkJASeW+rAtZv5D/BC+a+0fPkoMTS9aKnOw
         //E1GPOrDIwGVEL62ewndcth7KXqkeyXvEq3c=
Date: Tue, 26 Apr 2011 22:05:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110426190531.GA4556@p183>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -134,6 +134,17 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
>  			const void *from, size_t available);
>  
>  /**
> + * streq - Are two strings equal?
> + * @a: first string
> + * @b: second string
> + *
> + * Example:
> + *	if (streq(argv[1], "--help"))
> + *		printf("%s\n", "This help");
> + */

Oh, come on!
Next, you're going to explain if statement.

> +#define streq(a, b) (strcmp((a), (b)) == 0)

It should be inline function.
