Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1GUTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:39:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33478 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1GUTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:38:59 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Willy Tarreau <w@1wt.eu>, MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <20110721192545.GA6402@nik-comp.lan>
References: <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu>
	 <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins>
	 <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu>
	 <1311251098.29152.130.camel@twins>
	 <20110721125008.GF11246@pcnci.linuxbox.cz>
	 <1311252799.29152.147.camel@twins>  <20110721192545.GA6402@nik-comp.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 12:37:51 -0700
Message-ID: <1311277071.2945.213.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 21:25 +0200, Nikola Ciprich wrote:
> Hello Peter,
> 
> > With a patch that frobs the starting value close to overflowing I hope,
> > otherwise we'll not hear from you in like 7 months ;-)
> sure. Which is the best patch to use for testing, You mean john's one?
> (http://www.gossamer-threads.com/lists/linux/kernel/1406779#1406779)
> or some other?

http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=3eedec0ad10a856cf48ada066e88871d8ab427b3

Should do it.

thanks
-john


