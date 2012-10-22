Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2JVTib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:38:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33603 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab2JVTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:38:29 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] menuconfig: Replace CIRCLEQ by list_head-style lists.
Date: Mon, 22 Oct 2012 21:38:25 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.3-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
References: <1350754935-20014-1-git-send-email-benjamin.poirier@gmail.com> <1350811673-26081-1-git-send-email-benjamin.poirier@gmail.com>
In-Reply-To: <1350811673-26081-1-git-send-email-benjamin.poirier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210222138.25805.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, Michal, All,

On Sunday 21 October 2012 Benjamin Poirier wrote:
> From: Benjamin Poirier <bpoirier@suse.de>
> 
> sys/queue.h and CIRCLEQ in particular have proven to cause portability
> problems (reported on Debian Sarge, Cygwin and FreeBSD)

Benjamin,

Thank you for working on this! :-)

> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> ---
> 
> Changes v1-v2:
> * integrate the patch/suggestion from Yann to fix problems related to the
>   usage of list.h with xconfig/c++
> 	* "new" keyword
> 	* offsetof redefinition
> * silly #endif placement mistake

Michal,

Any more comments on this patch?

If not, then I would suggest to push it for inclusion before 3.7 is released
(I believe it can go in, as it is a bugfix, not a new feature).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
