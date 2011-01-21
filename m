Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1AUHTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:19:44 -0500
Received: from smtp.nokia.com ([147.243.128.26]:16867 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1AUHTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:19:42 -0500
Subject: Re: Checkpatch problem with Kconfig help symbol ?
From: Tapio Vihuri <tapio.vihuri@nokia.com>
Reply-To: tapio.vihuri@nokia.com
To: ext Michal Marek <mmarek@suse.cz>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <4D380279.4070502@suse.cz>
References: <1295440968.2276.46.camel@dell> <ih8qf2$41t$3@dough.gmane.org>
	 <4D380279.4070502@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Fri, 21 Jan 2011 09:19:31 +0200
Message-ID: <1295594371.27658.3.camel@dell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
> On 20.1.2011 09:06, WANG Cong wrote:
> > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
> > 
> >> Hi
> >>
> >> Is this false positive ?
> >>
> >> WARNING: please write a paragraph that describes the config symbol fully
> >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
> >>
> >>
> >> Interesting enough, also:
> >>
> >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
> >> please write a paragraph that describes the config symbol fully #430:
> >> FILE: input/misc/Kconfig:430:
> >> +       help
> >>
> >>
> >> But this is different line.
> >>
> > 
> > Seems yes, the Kconfig part of your patch looks fine.
> 
> The check is complaining that the help text is too short:
> 
> +config ECI_CTRL_DEBUG
> +	bool "ECI controller debug"
> +	depends on INPUT_ECI_AT20
> +	help
> +	  Say Y here to enable debugging messages for ECI controller driver.
> 
> Michal

Hi.

That I suspect, and I tried to add four lines more.
But it still complain the same.

Tapio

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


