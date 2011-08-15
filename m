Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1HOUR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:17:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59707 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HOURZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:17:25 -0400
Date: Mon, 15 Aug 2011 22:17:05 +0200
From: Florian Mickler <florian@mickler.org>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jay Ren <yongjie.ren@intel.com>, stefanha@linux.vnet.ibm.com,
        KVM General <kvm@vger.kernel.org>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Message-ID: <20110815221705.768b56f8@schatten.dmk.lab>
In-Reply-To: <4E496E7C.30303@redhat.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.nx.VNCSOB@chimera>
	<CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>
	<4E49215A.5080103@redhat.com>
	<1313416232.32391.13.camel@jaguar>
	<4E4928A1.1050104@redhat.com>
	<20110815163142.0182ce35@schatten.dmk.lab>
	<4E496E7C.30303@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 12:07:40 -0700
Avi Kivity <avi@redhat.com> wrote:

> On 08/15/2011 07:31 AM, Florian Mickler wrote:
> > On Mon, 15 Aug 2011 07:09:37 -0700
> > Avi Kivity<avi@redhat.com>  wrote:
> >
> > >  On 08/15/2011 06:50 AM, Pekka Enberg wrote:
> > >  >  Heh, sorry about that, that's the commit SHA mentioned in the above
> > >  >  bugzilla report. :-)
> > >  >
> > >  >
> > >
> > >  Think of it as 'git bisect good' input, rather than output.
> > >
> >
> > Can you post a comment to the bug when Linus pulled that tree?
> 
> Most likely kvm.git got that commit from Linus - I don't think the fix 
> came from kvm.git.
> 

Hm ok. But the tree tested by the reporter is contained in kvm/master
and kvm/next and not in Linus tree. 

Anyhow, Rafael did ask the correct question on the bug to resolve
this. :)

Regards,
Flo

