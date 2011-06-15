Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1FOVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:16:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60473 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1FOVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:16:08 -0400
Date: Wed, 15 Jun 2011 23:15:27 +0200
From: Florian Mickler <florian@mickler.org>
To: Alexander Zhaunerchyk <alex.vizor@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
Message-ID: <20110615231527.7701473b@schatten.dmk.lab>
In-Reply-To: <4DF9011D.6050107@gmail.com>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
	<JL7O0m0yLjL.A.vCD.COS9NB@chimera>
	<20110615114329.7429ff43@jbarnes-desktop>
	<4DF9011D.6050107@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 21:59:41 +0300
Alexander Zhaunerchyk <alex.vizor@gmail.com> wrote:

> I can't bisect. I tried to bisect other other bug but with some commits 
> I can't even boot, kernel hangs in panic.

You can try and use 'git bisect visualize' which will show you all
commits not yet eliminated from the bisection search. There you can
choose another commit to test (or just do a git reset --hard
[thatcommit]) or look for a fix to that problem higher up in the
commit list. 

Regards,
Flo
