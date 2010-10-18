Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0JRXHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:07:05 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62465 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab0JRXHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:07:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Dzv72v8volq644ONKVVvM
Date: Mon, 18 Oct 2010 16:06:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv3 00/11] staging tidspbridge: iommu migration
Message-ID: <20101018230655.GJ13341@atomide.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
 <496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
 <AANLkTim6XRgnefA0vmRNeW=TONhxz68WYAjuA96LqWOj@mail.gmail.com>
 <496565EC904933469F292DDA3F1663E602F47B3002@dlee06.ent.ti.com>
 <AANLkTik3hhWy+tRxThtrbwNXTssV7nf9+_LGn5Ct3iet@mail.gmail.com>
 <496565EC904933469F292DDA3F1663E602F48817EF@dlee06.ent.ti.com>
 <AANLkTi=juk+824k1R8mJrDostKhRz+nRNqj9E-rNYWrv@mail.gmail.com>
 <496565EC904933469F292DDA3F1663E602F4881816@dlee06.ent.ti.com>
 <AANLkTikfn9w-FMKXOVXibwHVy4vt72GdveDLVv0z3GmT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikfn9w-FMKXOVXibwHVy4vt72GdveDLVv0z3GmT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [101015 13:09]:
> On Fri, Oct 15, 2010 at 7:53 PM, Guzman Lugo, Fernando
> <fernando.lugo@ti.com> wrote:
> >> If you want I can provide my working branch on top of .36-rc8
> >> with next-staging merged. If I revert your patches, it works fine.
> >
> > That could be interested. Can you send me the link?
> 
> There you go:
> git://gitorious.org/~felipec/linux-omap/felipec.git (fc-dsp-work)
> 
> HEAD works, HEAD^ doesn't.

Great, can you please also let us know what if anything should
be still queued for the merge window that's about to open?

I've lost track of the dspbridge mutations by now..

Tony
