Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab2JRRz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:55:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63192 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2JRRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:55:54 -0400
Message-ID: <1350582958.3492.81.camel@YAAKOV04>
Subject: Re: [PATCH] kconfig/menuconfig: use TAILQ instead of CIRCLEQ
From: "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Benjamin Poirier <bpoirier@suse.de>
Date: Thu, 18 Oct 2012 12:55:58 -0500
In-Reply-To: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 19:33 +0200, Yann E. MORIN wrote:
> Some systems (eg. Cygwin, FreeBSD) are missing the CIRCLEQ macros.
> They were removed in Y2000 from FreeBSD:
>     http://svnweb.freebsd.org/base?view=revision&revision=70469
> 
> The reason was that TAILQ are perfectly capable of doing the exact
> same things:
>     http://www.mavetju.org/mail/view_thread.php?list=freebsd-arch&id=915145&thread=yes
> 
> (Thank Yaakov for the pointers!)

And thank you again for the heads-up.

> So, switch to using TAILQ instead, which are more portable.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Reported-by: Benjamin Poirier <bpoirier@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Tested-by: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>


