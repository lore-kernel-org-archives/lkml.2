Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2A3R7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:59:46 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:29691 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2A3R7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:59:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAFrZJk9bdWOb/2dsb2JhbABDr1yBcgEBBTIBGwgjEAsYLhQdCAMhCAsdBIdeBrgriCsGAQEBAwEBAQMBAwQQDQQDBDaDCwIBAwcCHXoEJwSDLASVGYktiSY
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="868546245"
Date: Mon, 30 Jan 2012 18:59:40 +0100
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
Message-ID: <20120130175940.GG27022@lit.local.igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
 <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
 <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:25:34AM -0600, Ramirez Luna, Omar wrote:
> 2012/1/23 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
> > No functional changes.
> >
> > According to Lindent, the file drv_internface.c had some lines with bad
> > indentation.
> >
> > This commit is the output of Lindent.
> 
> Usually lindent tends to do whatever it wants, unless carefully
> configured...

Thanks Omar!

I'll post a v2 of this patch set, with a couple things more and with more
attention on what lindent does in this one, if that's ok.

vmjl

> 
> ...
> > @@ -342,9 +342,10 @@ static void bridge_recover(struct work_struct *work)
> >        if (atomic_read(&bridge_cref)) {
> >                INIT_COMPLETION(bridge_comp);
> >                while (!wait_for_completion_timeout(&bridge_comp,
> > -                                               msecs_to_jiffies(REC_TIMEOUT)))
> > -                       pr_info("%s:%d handle(s) still opened\n",
> > -                                       __func__, atomic_read(&bridge_cref));
> > +                                                   msecs_to_jiffies
> > +                                                   (REC_TIMEOUT)))
> 
> Like here, it just split msecs_to_jiffies(REC_TIMEOUT) into 2 lines
> making it a little harder to read.
> 
> > +                       pr_info("%s:%d handle(s) still opened\n", __func__,
> > +                               atomic_read(&bridge_cref));
> 
> I remember the rule was to break lines as far to the right as
> possible, no? Chapter 2 CodingStyle, same for the other similar
> changes.
> 
> ...
> > @@ -547,10 +548,9 @@ static int __devexit omap34_xx_bridge_remove(struct platform_device *pdev)
> >                pr_err("%s: Failed to retrieve the object handle\n", __func__);
> >                goto func_cont;
> >        }
> > -
> 
> Blank line removed?
> 
> >  #ifdef CONFIG_TIDSPBRIDGE_DVFS
> >        if (cpufreq_unregister_notifier(&iva_clk_notifier,
> > -                                               CPUFREQ_TRANSITION_NOTIFIER))
> > +                                       CPUFREQ_TRANSITION_NOTIFIER))
> >                pr_err("%s: cpufreq_unregister_notifier failed for iva2_ck\n",
> >                       __func__);
> >  #endif /* #ifdef CONFIG_TIDSPBRIDGE_DVFS */
> > --
> > 1.7.8.3
> >
> 
> Regards,
> 
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
