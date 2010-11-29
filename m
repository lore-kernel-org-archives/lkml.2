Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0K2WD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:03:57 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54817 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0K2WD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CPato8necWA461vh4YGz937/HQnurxZZ1ipgv11Sm+9qa/exdVWfhFWgAvzAQY3/TK
         71paY3syzTeX5+KLC3AV8CkNjlzj1Fpo5FiSmQPj/2G5YvRIgS3w93SUwed+H21Vg8jG
         53RrIJynpFuaxXw/nFaohGz9zGwL65cnvF/ws=
Date: Tue, 30 Nov 2010 00:03:50 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: =?utf-8?B?5LmU5bSH?= <qiaochong@loongson.cn>, hellogcc@freelists.org,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101129220350.GA10923@core2.telecom.by>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com>
 <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
 <4CF36741.9000808@loongson.cn>
 <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
 <4CF3762B.9010102@loongson.cn>
 <13700.1291054229@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13700.1291054229@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 01:10:29PM -0500, Valdis.Kletnieks@vt.edu wrote:
> That may result in issues - the problem is that there are places in the kernel
> where 'gcc -O0' will *compile* cleanly, but not actually *run* correctly.

Since nobody (no-bo-dy) runs kernel with -O0, I'd suggest original
poster to learn how to debug kernel with constrained information.

I'll be most certainly faster. :^)
