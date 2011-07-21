Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1GUMy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:54:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59707 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1GUMyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:54:25 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: Peter Zijlstra <peterz@infradead.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>, MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <20110721125008.GF11246@pcnci.linuxbox.cz>
References: <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu>
	 <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins>
	 <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu>
	 <1311251098.29152.130.camel@twins>
	 <20110721125008.GF11246@pcnci.linuxbox.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 14:53:19 +0200
Message-ID: <1311252799.29152.147.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> thanks for the patch! I'll put this on our testing boxes...

With a patch that frobs the starting value close to overflowing I hope,
otherwise we'll not hear from you in like 7 months ;-)

> Are You going to push this upstream so we can ask Greg to push this to
> -stable? 

Yeah, I think we want to commit this with a -stable tag, Ingo?
