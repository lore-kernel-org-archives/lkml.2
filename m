Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2J1O0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 10:26:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51971 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750860Ab2J1O0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 10:26:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//EiBE4CL/YrvcRyr20tPapqqV7J1g9c5BuOkiuu
	9sF+fPuf8M6NSS
Message-ID: <1351434428.4595.3.camel@maggy.simpson.net>
Subject: Re: [PATCH] sched, autogroup: fix crash on reboot when autogroup is
 disabled
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Sun, 28 Oct 2012 07:27:08 -0700
In-Reply-To: <20121028140544.GA28216@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
	 <1351283371.16639.111.camel@maggy.simpson.net>
	 <1351362370.4503.3.camel@maggy.simpson.net>
	 <20121028102520.GA7711@gmail.com>
	 <1351430004.8685.17.camel@maggy.simpson.net>
	 <20121028131950.GA15159@gmail.com>
	 <1351431201.8685.22.camel@maggy.simpson.net>
	 <20121028140544.GA28216@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 15:05 +0100, Ingo Molnar wrote:

> I'd also suggest to still expose the state of autosched in 
> /proc/sys, read-only, so that its status can be checked.

(Aw poo, less pretty minus signs;)

Ok, will do.

-Mike

