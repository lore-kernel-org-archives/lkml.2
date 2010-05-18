Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0ERVm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:42:28 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:41130 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751964Ab0ERVm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:42:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JmPi+P7jZyqiu2eVbgcYsHbZu2j5wqyJa2/p0bWciK5yZSgXJcETHNmh1iWR/ZpLybsSsoUYxzL/C/De6FJ89fNjxilTyITsggoK9VS+0zPjc6hVpDo++63N9MeU3j+U;
Date: Tue, 18 May 2010 14:41:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vgacon: use request_region(), not
 request_resource(), to set BUSY
Message-ID: <20100518144105.362e5e6a@virtuousgeek.org>
In-Reply-To: <4BE08013.5060402@zytor.com>
References: <20100504185801.7244.39173.stgit@bob.kio>
	<20100504185806.7244.96960.stgit@bob.kio>
	<alpine.LFD.2.00.1005041207380.5478@i5.linux-foundation.org>
	<201005041316.51113.bjorn.helgaas@hp.com>
	<4BE08013.5060402@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 May 2010 13:14:11 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/04/2010 12:16 PM, Bjorn Helgaas wrote:
> > On Tuesday, May 04, 2010 01:09:46 pm Linus Torvalds wrote:
> >> On Tue, 4 May 2010, Bjorn Helgaas wrote:
> >>> Drivers normally use request_region() to mark the region busy so it won't
> >>> be used by anybody else.  Previously, we used request_resource(), which
> >>> doesn't mark the VGA regions busy.
> >>>
> >>> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >>
> >> Hmm. I don't object, but unless there is some crazy regression, there's no
> >> way I will take something like this outside the merge window. Who knows
> >> what odd frame buffer driver is out there that just depended on the fact
> >> that it could also register that VGA area?
> >>
> >> Probably no such thing exists, but it's why I want these kinds of things
> >> during the merge window. And obviously preferably through something like
> >> the PCI merge tree, but that's a different issue.
> > 
> > Yep, I was intending for after .34.  I couldn't figure out where
> > to send it, but I'll be happy to send it to Jesse.
> > 
> 
> I would vote for Jesse's tree.  If Jesse doesn't want it I'll take it.

Can you resend this one Bjorn?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
