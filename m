Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2JUByH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 21:54:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57379 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2JUByF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 21:54:05 -0400
Message-ID: <1350784440.1244.6.camel@YAAKOV04>
Subject: Re: [PATCH] menuconfig: Replace CIRCLEQ by list_head-style lists.
From: "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>
To: Benjamin Poirier <benjamin.poirier@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Michal Marek <mmarek@suse.cz>, Jean Sacren <sakiwit@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sat, 20 Oct 2012 20:54:00 -0500
In-Reply-To: <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr>
	 <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 13:56 -0400, Benjamin Poirier wrote:
> From: Benjamin Poirier <bpoirier@suse.de>
> menuconfig: Replace CIRCLEQ by list_head-style lists
> 
> sys/queue.h and CIRCLEQ in particular have proven to cause portability
> problems (reported on Debian Sarge, Cygwin and FreeBSD)
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>


> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> kconfig: fix building the qconf frontend
> 
> Also, protect the whole file with the #ifdenf LIST_H, not only the
> macros
> defintions.
> 
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Squash these two together and all frontends build again on Cygwin.

Tested-by: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>

