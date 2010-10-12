Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab0JLVd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:33:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55486 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0JLVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:33:27 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xBotvFMlRt0fW9GOb/GLt
Date: Tue, 12 Oct 2010 14:01:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephan Linz <linz@li-pro.net>
Cc: Ashwin Bihari <abihari@gmail.com>, Tim Nordell <tim.nordell@logicpd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and
 Torpedo
Message-ID: <20101012210150.GA25462@atomide.com>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
 <4CB34D55.6060007@logicpd.com>
 <AANLkTikK6QAwj_T67NQAhVDT2T+D3tbBbOt9vDyme6N=@mail.gmail.com>
 <201010122120.26977.linz@li-pro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201010122120.26977.linz@li-pro.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephan Linz <linz@li-pro.net> [101012 12:11]:
> Am Montag, 11. Oktober 2010, um 20:40:51 schrieb Ashwin Bihari:
> > On Mon, Oct 11, 2010 at 1:45 PM, Tim Nordell <tim.nordell@logicpd.com> 
> wrote:
> > >  On 10/11/10 12:30, Tony Lindgren wrote:
> > >> Uhh, so whose patches are these originally?
> > >>
> > >> We have them now queued with Tim Nordell as the author. Please let me
> > >> know ASAP if you want me to change that.
> 
> Hi Tony,
> 
> No, I don't want to change anything. Only the LogicPD employees should be 
> named inside the pathes as far as the patches are not a direct pull from my 
> own devel tree on Gitorious. Ashwin has done a good explanation of the 
> situation.

OK, thanks everybody, keeping the commits as they are.

Regards,

Tony

> 
> 
> - Stephan
> 
> 
> > >>
> > >> Regards,
> > >>
> > >> Tony
> > >
> > > The history for those patches, for me, originated with Jacob Tanenbaum's
> > > patchset.  I was taking over for him as he was going back to school.  I
> > > did some misc. changes for further submission, but I was not the
> > > original author.  I don't know Stephan's involvement - however, in the
> > > source files he's attributed credit in the header, as well as one of my
> > > coworkers so presumably there was some involvement on both ends.  I
> > > recognize some of the code as coming from our kernel release, so likely
> > > it was a hybrid originally between Stephan, Peter, and Jacob.
> > >
> > > That's about the extent that I know.
> > >
> > > - Tim
> >
> > Tony,
> >
> > LogicPD engineers did the initial porting and then Stephan Linz
> > re-started the work on the, then recent, 2.6.32 Kernel using our BSP
> > as a starting point. He was kind enough to send those LogicPD and we
> > began putting it together against the latest Linux Kernel for
> > inclusion and that was done by Jacob over the summer and finished off
> > by Tim.
> >
> > Stephan Linz is credited in the patch and Peter Barada (another
> > LogicPD employee) is listed as the maintainer though his part (along
> > with me) in getting these specific patches out have been more behind
> > the scenes. So having the names listed as they are now is OK.
> >
> > In the upcoming months we will be pushing out additional support for
> > the LogicPD's boards and it will most likely come up a variety of
> > LogicPD engineers depending on our workload..
> >
> > Thanks
> > -- Ashwin
> 
> 
> -- 
> Viele Grüße,
> Stephan Linz
> ______________________________________________________________________________
> OpenDCC: http://www.li-pro.net/opendcc.phtml
> PC/M: http://www.li-pro.net/pcm.phtml
> CDK4AVR: http://cdk4avr.sourceforge.net/
> CDK4NIOS: http://cdk4nios.sourceforge.net/
> CDK4MSP: http://cdk4msp.sourceforge.net/
> CPM4L: http://download.opensuse.org/repositories/home:/rexut:/CPM4L
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
