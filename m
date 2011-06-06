Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1FFKk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:40:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1FFKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CIImyzYoddZPi/8IMeuhjPElXjhKZIdBbac9dLUdnFuHMc5XRph+JUb4/CQx6kAegW
         sHD8Ixn78uBw8mwzfWX6xZS5hNkm05HnQfJhasP0s2Fbau+v3BcmoMCXhx4FUe+Ne8sj
         9yRdAs6sHyDIrvteJgidcZcN329wb09E36t3s=
Subject: Re: [PATCH RFC] fs: introduce a default_open for simple f_op->open
 use
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, matthew@wil.cx, dwmw2@infradead.org,
        robert.richter@amd.com, gregkh@suse.de, jmorris@namei.org,
        npiggin@kernel.dk, ak@linux.intel.com, dchinner@redhat.com
In-Reply-To: <201106021504.55799.hartleys@visionengravers.com>
References: <201106021504.55799.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 13:36:10 +0300
Message-ID: <1307356570.3112.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 15:04 -0700, H Hartley Sweeten wrote:
> There are many f_op->open implementations that simply do:
> 
> 	file->private_data = inode->i_private;
> 
> This introduces a new global symbol, default_open, that can be
> used instead of the private implementations.
> 
> This also removes a couple private implementations that share the
> same symbol name.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: James Morris <jmorris@namei.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> 
> ---
> 
> If this patch looks reasonable, I have some additional patches that
> convert all other similar f_op->open implemenations to use default_open
> tree wide.  The full diffstat looks like this:

Looks good to me, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

