Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1GYNPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:15:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53120 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1GYNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:14:59 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Sasha Levin <levinsasha928@gmail.com>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
In-Reply-To: <8B9ECC32-2AD9-49D9-B120-A726B32AD1B4@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	 <4E2CA6DE.4040900@web.de>
	 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	 <20110725075305.GA32294@elte.hu>
	 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
	 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
	 <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
	 <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
	 <B0466610-8355-402E-B378-68BD3AF9CE2D@suse.de>
	 <CAOJsxLFT-E5E3YFT5es8FkTfgu1xTvqf-k+WqgH47U+ZKxVVoQ@mail.gmail.com>
	 <4E2D65D7.6030407@redhat.com> <1311598300.10256.10.camel@lappy>
	 <8B9ECC32-2AD9-49D9-B120-A726B32AD1B4@suse.de>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 25 Jul 2011 16:14:25 +0300
Message-ID: <1311599665.10256.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 14:54 +0200, Alexander Graf wrote:
> On 25.07.2011, at 14:51, Sasha Levin wrote:
> 
> > On Mon, 2011-07-25 at 15:47 +0300, Avi Kivity wrote:
> >> On 07/25/2011 03:45 PM, Pekka Enberg wrote:
> >>> On Mon, Jul 25, 2011 at 12:06 PM, Alexander Graf<agraf@suse.de>  wrote:
> >>>>> And don't get this the wrong way either, I'm not hostile against other
> >>>>> operating systems, but I simply am not interested enough in them to
> >>>>> spend my time improving them.
> >>>> 
> >>>> Then kvm-tool is about as useful as Mac-on-Linux. Why don't we have MoL user land in the kernel? I even added support for KVM to it about a year ago. So all I need to do is change it to the kernel coding style, add some dependencies on kernel headers and I'm good for a pull request?
> >>> 
> >>> Oh, I dunno - have you tried that? If you're interested in sending a
> >>> patch against tools/kvm that adds KVM-based support to Mac, I'm happy
> >>> to review it and consider for inclusion. ;-)
> >> 
> >> The patch will be a lot bigger than tools/kvm itself.
> >> 
> > 
> > But it would be as a single patch series which includes kvm and
> > tools/kvm :)
> 
> Not sure I get what you mean here. We already have KVM support for Macs ;). And pSeries. And the PS3. It even works on the Wii.

I assumed from Avi's comment that we don't have KVM for Macs. Ignore me
then.

-- 

Sasha.

