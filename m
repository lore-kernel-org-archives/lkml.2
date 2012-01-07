Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2AGIWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 03:22:20 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62462 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2AGIWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 03:22:19 -0500
Date: Sat, 7 Jan 2012 09:22:12 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: initial support for sta2x11
Message-ID: <20120107082212.GA18254@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1325894723.12292.13.camel@joe2Laptop>
References: <1325894723.12292.13.camel@joe2Laptop>
    <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
  <1446410617.668.1325893939253.JavaMail.mail@webmail05>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> trivia:

Thanks.

> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Ok.

> typo: s/subordindate/subordinate/

argh!

> It's probably not necessary to prefix with "sta2x11: "

fine.

> 
>> +			 size);
>> +		if (swiotlb_late_init_with_default_size(size))
>> +			dev_emerg(&pdev->dev, "%s: init swiotlb(%i) failed\n",
>> +				  __func__, size);
> 
> or __func__

I don't understand. No size? Or you typoed and meant pr_fmt defined above?

>> +	uint32_t v[2]; /* used as a string... */
> 
> less than pretty.

Sure. But it's informative. Do you prefer a union? I don't want to
do be/le stuff as it's irrelevant. But I can't read 1 byte at a time
nor use a pointer there.

thanks, will resend

/alessandro
