Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2APHVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:21:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APHU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:20:59 -0500
Message-ID: <1326698421.4151.4.camel@cr0>
Subject: Re: [PATCH] kconfig: fix a regression when exiting menuconfig
 without saving
From: Cong Wang <amwang@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Davidlohr Bueso <dave@gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Date: Mon, 16 Jan 2012 15:20:21 +0800
In-Reply-To: <4F13CB49.8030004@cn.fujitsu.com>
References: <4F13CB49.8030004@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 15:01 +0800, Li Zefan wrote:
> $ make menuconfig
>   HOSTCC  scripts/kconfig/mconf.o
>   HOSTLD  scripts/kconfig/mconf
> scripts/kconfig/mconf Kconfig
> 
> Your configuration changes were NOT saved.
> 
> make[1]: *** [menuconfig] Error 1
> make: *** [menuconfig] Error 2
> 
> Exiting menuconfig without saving, make will report error.

This should be fixed by "[PATCH] scripts:kconfig:mconf.c: let make not
report error when not save configuration".

Thanks.

