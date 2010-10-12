Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0JLTUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:20:34 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:52466 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0JLTUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:20:32 -0400
X-RZG-AUTH: :IGUKb2CkcrLHmZv+FHarxbxlXmJO7WRQLa+vsyW+4RNNIht4SfHkWqUM8pxP
X-RZG-CLASS-ID: mo00
From: Stephan Linz <linz@li-pro.net>
Organization: Li-Pro.Net
To: Ashwin Bihari <abihari@gmail.com>
Subject: Re: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and Torpedo
Date: Tue, 12 Oct 2010 21:20:26 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.28-19-generic; KDE/4.2.4; x86_64; ; )
Cc: Tim Nordell <tim.nordell@logicpd.com>, Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com> <4CB34D55.6060007@logicpd.com> <AANLkTikK6QAwj_T67NQAhVDT2T+D3tbBbOt9vDyme6N=@mail.gmail.com>
In-Reply-To: <AANLkTikK6QAwj_T67NQAhVDT2T+D3tbBbOt9vDyme6N=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010122120.26977.linz@li-pro.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 11. Oktober 2010, um 20:40:51 schrieb Ashwin Bihari:
> On Mon, Oct 11, 2010 at 1:45 PM, Tim Nordell <tim.nordell@logicpd.com> 
wrote:
> >  On 10/11/10 12:30, Tony Lindgren wrote:
> >> Uhh, so whose patches are these originally?
> >>
> >> We have them now queued with Tim Nordell as the author. Please let me
> >> know ASAP if you want me to change that.

Hi Tony,

No, I don't want to change anything. Only the LogicPD employees should be 
named inside the pathes as far as the patches are not a direct pull from my 
own devel tree on Gitorious. Ashwin has done a good explanation of the 
situation.


- Stephan


> >>
> >> Regards,
> >>
> >> Tony
> >
> > The history for those patches, for me, originated with Jacob Tanenbaum's
> > patchset.  I was taking over for him as he was going back to school.  I
> > did some misc. changes for further submission, but I was not the
> > original author.  I don't know Stephan's involvement - however, in the
> > source files he's attributed credit in the header, as well as one of my
> > coworkers so presumably there was some involvement on both ends.  I
> > recognize some of the code as coming from our kernel release, so likely
> > it was a hybrid originally between Stephan, Peter, and Jacob.
> >
> > That's about the extent that I know.
> >
> > - Tim
>
> Tony,
>
> LogicPD engineers did the initial porting and then Stephan Linz
> re-started the work on the, then recent, 2.6.32 Kernel using our BSP
> as a starting point. He was kind enough to send those LogicPD and we
> began putting it together against the latest Linux Kernel for
> inclusion and that was done by Jacob over the summer and finished off
> by Tim.
>
> Stephan Linz is credited in the patch and Peter Barada (another
> LogicPD employee) is listed as the maintainer though his part (along
> with me) in getting these specific patches out have been more behind
> the scenes. So having the names listed as they are now is OK.
>
> In the upcoming months we will be pushing out additional support for
> the LogicPD's boards and it will most likely come up a variety of
> LogicPD engineers depending on our workload..
>
> Thanks
> -- Ashwin


-- 
Viele Grüße,
Stephan Linz
______________________________________________________________________________
OpenDCC: http://www.li-pro.net/opendcc.phtml
PC/M: http://www.li-pro.net/pcm.phtml
CDK4AVR: http://cdk4avr.sourceforge.net/
CDK4NIOS: http://cdk4nios.sourceforge.net/
CDK4MSP: http://cdk4msp.sourceforge.net/
CPM4L: http://download.opensuse.org/repositories/home:/rexut:/CPM4L
