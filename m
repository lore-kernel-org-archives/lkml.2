Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1CVKKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:10:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1CVKKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:10:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
Date: Tue, 22 Mar 2011 11:10:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de> <20110322092113.GB17264@n2100.arm.linux.org.uk>
In-Reply-To: <20110322092113.GB17264@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221110.20861.arnd@arndb.de>
X-Provags-ID: V02:K0:Z03CszQQ+iS0otjoiicts2Jxqp4f4q+IzeU/tsCqOL8
 RUnuWtxMWFQTqHLL24Qd+PE4aWnxtFsG7QMleWgllYwlcOzuFH
 20nQgg1MD7/v3HF8cnCW7YVlf3F6as3TjwhRUQ28ay6kP7HBpY
 ooyWQqoq+0t8PnQCjVz6BwdmMQxrpaMR65WChOuEIElhZj2clw
 10rLiRg6SpBSqC5DF7cvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, Russell King - ARM Linux wrote:
> On Tue, Mar 22, 2011 at 09:34:50AM +0100, Arnd Bergmann wrote:
> > On Tuesday 22 March 2011, Stephen Boyd wrote:
> > > Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
> > > introduced a generic sizes.h. Use that instead of the ARM specific
> > > version.
> > > 
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de
> 
> I assume the generic version was derived from the ARM version.  Is there
> a reason why ARM Ltd's copyright was seemingly dropped?

I'll let Guan Xuetao answer that, he introduced the file along with the
unicore32 architecture.

I doubt that the contents of this file are copyrightable, but of course
that is normally no reason to remove the notice.

	Arnd
