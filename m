Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0GQNv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 09:51:59 -0400
Received: from xenotime.net ([72.52.115.56]:60177 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753485Ab0GQNvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 09:51:54 -0400
Date: Sat, 17 Jul 2010 06:51:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org,
        Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
Message-Id: <20100717065146.732f5449.rdunlap@xenotime.net>
In-Reply-To: <m3tyny31mo.fsf@intrepid.localdomain>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
	<m3tyny31mo.fsf@intrepid.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jul 2010 11:21:03 +0200 Krzysztof Halasa wrote:

> Dimitrios Apostolou <jimis@gmx.net> writes:
> 
> > static void update_group_shares_cpu(struct task_group *tg, int cpu,
> >                                     unsigned long sd_shares,
> >                                     unsigned long sd_rq_weight,
> >                                     unsigned long *usd_rq_weight)
> > {
> 
> From a technical POV the above should not have any tabs, the parameters
> should be aligned with spaces only.

fwiw, it seems that you agree with Ted.

> The tabs should be used for (syntactic) indentation only.
> 
> This way we can display the code correctly with any tab length.

but we know what the tab length is.  ;)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
