Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1DDMuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:50:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41898 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1DDMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pb+9F4S+dl8iS+LQxG19fk4E+KBpEtSLj2i8RB4bTp0/gzN8BAAFkViu7TvXVeHP9Y
         JooW8Kw94G2sUEQbZjGPr1ZU2euc0UPwHyvzj7j+EbmBwsXUVDy2OJFTFjEh3sxYjCXA
         Dtu/AtjtfcFZGbQ5fghq6MJgZbPnYlkr/lCz4=
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to
 Makefile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>
In-Reply-To: <4D99B6CC.7080707@suse.cz>
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>
	 <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
	 <4D99B6CC.7080707@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 15:48:04 +0300
Message-ID: <1301921284.2760.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 14:17 +0200, Michal Marek wrote:
> > -ifdef CONFIG_KALLSYMS_EXTRA_PASS
> > -last_kallsyms := 3
> > -else
> >  last_kallsyms := 2
> > +ifeq ("$(origin KALLSYMS_EXTRA_PASS)", "command line")
> 
> I would drop the origin check here. We use it for single-letter
> variables that could be used outside the kernel with a different
> meaning, but if you export KALLSYMS_EXTRA_PASS, then you certainly mean
> the kernel's KALLSYMS_EXTRA_PASS.

Sure, I'll wait if there are more requests and re-send. There is a
missed white-space in the first patch as well which I'll fix.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

