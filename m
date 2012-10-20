Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2JTVWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 17:22:13 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:43453 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2JTVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 17:22:11 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Subject: Re: [PATCH] menuconfig: Replace CIRCLEQ by list_head-style lists.
Date: Sat, 20 Oct 2012 23:22:06 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Jean Sacren <sakiwit@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@gmail.com>
References: <1350581625-23153-1-git-send-email-yann.morin.1998@free.fr> <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
In-Reply-To: <1350755792-21217-1-git-send-email-benjamin.poirier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210202322.07188.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, All,

On Saturday 20 October 2012 Benjamin Poirier wrote:
> From: Benjamin Poirier <bpoirier@suse.de>
> 
> sys/queue.h and CIRCLEQ in particular have proven to cause portability
> problems (reported on Debian Sarge, Cygwin and FreeBSD)
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Thank you for this patch! I guess it is the best solution we can get.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
