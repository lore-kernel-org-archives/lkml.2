Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031765Ab2CGBNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:13:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60748 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031740Ab2CGBNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:13:36 -0500
Message-ID: <1331082811.2191.167.camel@work-vm>
Subject: Re: WARNING: Adjusting tsc more then 11%
From: John Stultz <john.stultz@linaro.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 06 Mar 2012 17:13:31 -0800
In-Reply-To: <CA+1xoqeKMVzSEMef+Yg6yBSyObN4pWA9cVf7t72SBJ0W==MNqQ@mail.gmail.com>
References: <20120305154411.GA29668@redhat.com>
	 <1330972323.2191.74.camel@work-vm> <20120305192338.GA30491@redhat.com>
	 <1330977010.2191.84.camel@work-vm> <20120305195758.GA25498@redhat.com>
	 <CA+1xoqfYbC30dFDOtfAVcr5w0WYAS1ruKFS-rcRAEv2ZqaGW6w@mail.gmail.com>
	 <1330979254.2191.98.camel@work-vm>
	 <CA+1xoqeKMVzSEMef+Yg6yBSyObN4pWA9cVf7t72SBJ0W==MNqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030701-7282-0000-0000-0000072671A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 22:36 +0200, Sasha Levin wrote:
> On Mon, Mar 5, 2012 at 10:27 PM, John Stultz <john.stultz@linaro.org> wrote:
> > On Mon, 2012-03-05 at 22:16 +0200, Sasha Levin wrote:
> >> On Mon, Mar 5, 2012 at 9:57 PM, Dave Jones <davej@redhat.com> wrote:
> >> > On Mon, Mar 05, 2012 at 11:50:10AM -0800, John Stultz wrote:
> >> >
> >> >  > So it would be great to get further feedback from folks who are seeing
> >> >  > this warning, so we can really hammer this out, but I don't want the
> >> >  > warning spooking anyone into thinking things are terribly broken.
> >> >
> >> > One of the reports was from someone using vbox. I'm now wondering if
> >> > the other users are using some other flavour of virt. I'll ask.
> >>
> >> I've reported this issue with regards to KVM before
> >> (http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/85632) but
> >> according to this thread it's not really KVM specific.
> >>
> >> It's easily reproducible using Dave's trinity running inside a KVM guest.
> >
> > Great! Do you have a link to trinity? (Google just gives me a video of
> > its use and links to various churches)
> 
> Sure, the git tree is here: codemonkey.org.uk/projects/trinity/trinity.git
> 
> Basically just start 2*vcpu instances of trinity inside the guest and
> wait a bit.

So I left trinity running in a 2vcpu kvm guest for ~5 hours and haven't
seen anything yet. Could you send me a .config for the guest kernel and
maybe your kvm command line? 

Also, it shouldn't really matter, but are the guests 32bit or 64bit?

thanks
-john


