Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1GaWYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:24:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1GaWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:24:27 -0400
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
From: David Woodhouse <dwmw2@infradead.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Sun, 31 Jul 2011 23:24:21 +0100
In-Reply-To: <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
References: <1312066693.22074.50.camel@i7.infradead.org>
	 <1312066923.22074.53.camel@i7.infradead.org>
	 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312151063.18010.25.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 00:11 +0200, richard -rw- weinberger wrote:
> 
> Why do we need this? 

The arch/x86_64 and arch/i386 directories were removed from the kernel
four years ago, and replaced by the 'x86' arch. UML is still dependent
on the legacy SUBARCH=i386 and SUBARCH=x86_64 settings, and the patch
sequence I just posted makes it cope with SUBARCH=x86.

-- 
dwmw2

