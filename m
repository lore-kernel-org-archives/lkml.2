Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0FNTVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:21:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57954 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab0FNTV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:21:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
In-Reply-To: <20100614182212.GA14747@merkur.ravnborg.org>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org> <20100614182212.GA14747@merkur.ravnborg.org>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Mon, 14 Jun 2010 20:21:27 +0100
Message-ID: <874oh5zah4.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 20:22:12 +0200, Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> The patch above we would match the section ".text.*" too soon and
> add the .text..lock section at the wrong place.
> 
> Browsing the vmlinux.lds files other archs will be impacted too.

Yeah, good point. James Bottomley has already pointed out how this
change completely breaks parisc. I'll drop this series.

Thanks for the review!
