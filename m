Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0GYJYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 05:24:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49991 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0GYJY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 05:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BXzJut69A8LCApo7/nLZ/rszfJbzmWddsh/WPWkhLajEOEWQ4VPih2wqJdtO/ncxKf
         ZWKJAQuV6ojbBPV8PUlvbyVH9UOKXg1VkDBJ35tC2JGTXiwAnjwF6Zk144tmHVW20a3R
         HfSmQ5sNtY2jxzmDogl7MOLXYBx0SWnIeQ3Uw=
Date: Sun, 25 Jul 2010 13:23:54 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: check capabilities in open()
Message-ID: <20100725092354.GA7728@albatros>
References: <20100724160701.GA4907@albatros>
 <20100724182355.GA9134@ZenIV.linux.org.uk>
 <20100725054511.GB9018@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725054511.GB9018@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 09:45 +0400, Vasiliy Kulikov wrote:
> Btw, the list of such drivers is much smaller, some of them just return
> -EPERM and open() fails, it is OK. I'll resend more precise list soon.

The list is tiny:

arch/x86/kernel/apm_32.c
drivers/char/agp/frontend.c
drivers/char/apm-emulation.c

Aslo comment from drivers/cahr/apm-emulation.c:

/*
 * XXX - this is a tiny bit broken, when we consider BSD
 * process accounting.  If the device is opened by root, we
 * instantly flag that we used superuser privs. Who knows,
 * we might close the device immediately without doing a
 * privileged operation -- cevans
 */
