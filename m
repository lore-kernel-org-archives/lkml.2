Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2DDVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61326 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab2DDVQJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120404210507.GA1716@kroah.com>
References: <1333569554.864.3.camel@mop>
	<20120404210507.GA1716@kroah.com>
Date: Wed, 4 Apr 2012 23:16:07 +0200
Message-ID: <CAFLxGvzVccmuUKpbdqWfi+JEsgk2X59hK=C7RWY2q5+a2JjR2g@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Greg Kroah-Hartmann <greg@kroah.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 11:05 PM, Greg Kroah-Hartmann <greg@kroah.com> wrote:
> I just noticed that 'tail -f' doesn't seem to work on /dev/kmsg, should
> it?  Or does it need to do something else to get "just the new ones"?
>

AFAIK tail looks at the file size/timestamp to detect modifications...

-- 
Thanks,
//richard
