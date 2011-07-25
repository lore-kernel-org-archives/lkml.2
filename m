Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1GYMwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:52:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64295 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1GYMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:52:14 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
In-Reply-To: <4E2D65D7.6030407@redhat.com>
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
	 <4E2D65D7.6030407@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 25 Jul 2011 15:51:40 +0300
Message-ID: <1311598300.10256.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 15:47 +0300, Avi Kivity wrote:
> On 07/25/2011 03:45 PM, Pekka Enberg wrote:
> > On Mon, Jul 25, 2011 at 12:06 PM, Alexander Graf<agraf@suse.de>  wrote:
> > >>  And don't get this the wrong way either, I'm not hostile against other
> > >>  operating systems, but I simply am not interested enough in them to
> > >>  spend my time improving them.
> > >
> > >  Then kvm-tool is about as useful as Mac-on-Linux. Why don't we have MoL user land in the kernel? I even added support for KVM to it about a year ago. So all I need to do is change it to the kernel coding style, add some dependencies on kernel headers and I'm good for a pull request?
> >
> > Oh, I dunno - have you tried that? If you're interested in sending a
> > patch against tools/kvm that adds KVM-based support to Mac, I'm happy
> > to review it and consider for inclusion. ;-)
> 
> The patch will be a lot bigger than tools/kvm itself.
> 

But it would be as a single patch series which includes kvm and
tools/kvm :)

-- 

Sasha.

