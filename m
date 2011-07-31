Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1GaWsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:48:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33163 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1GaWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:48:39 -0400
Date: Sun, 31 Jul 2011 23:48:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110731224834.GC2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
 <1312066923.22074.53.camel@i7.infradead.org>
 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
 <1312151063.18010.25.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312151063.18010.25.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 11:24:21PM +0100, David Woodhouse wrote:
> On Mon, 2011-08-01 at 00:11 +0200, richard -rw- weinberger wrote:
> > 
> > Why do we need this? 
> 
> The arch/x86_64 and arch/i386 directories were removed from the kernel
> four years ago, and replaced by the 'x86' arch. UML is still dependent
> on the legacy SUBARCH=i386 and SUBARCH=x86_64 settings, and the patch
> sequence I just posted makes it cope with SUBARCH=x86.

Hell, no.  If you want to do it, do it the right way.  See #x86_merge in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/
