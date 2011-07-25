Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1GYMsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1GYMsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:48:05 -0400
Message-ID: <4E2D65D7.6030407@redhat.com>
Date: Mon, 25 Jul 2011 15:47:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>	<4E2CA6DE.4040900@web.de>	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>	<20110725075305.GA32294@elte.hu>	<0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>	<CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>	<ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>	<CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>	<B0466610-8355-402E-B378-68BD3AF9CE2D@suse.de> <CAOJsxLFT-E5E3YFT5es8FkTfgu1xTvqf-k+WqgH47U+ZKxVVoQ@mail.gmail.com>
In-Reply-To: <CAOJsxLFT-E5E3YFT5es8FkTfgu1xTvqf-k+WqgH47U+ZKxVVoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 03:45 PM, Pekka Enberg wrote:
> On Mon, Jul 25, 2011 at 12:06 PM, Alexander Graf<agraf@suse.de>  wrote:
> >>  And don't get this the wrong way either, I'm not hostile against other
> >>  operating systems, but I simply am not interested enough in them to
> >>  spend my time improving them.
> >
> >  Then kvm-tool is about as useful as Mac-on-Linux. Why don't we have MoL user land in the kernel? I even added support for KVM to it about a year ago. So all I need to do is change it to the kernel coding style, add some dependencies on kernel headers and I'm good for a pull request?
>
> Oh, I dunno - have you tried that? If you're interested in sending a
> patch against tools/kvm that adds KVM-based support to Mac, I'm happy
> to review it and consider for inclusion. ;-)

The patch will be a lot bigger than tools/kvm itself.

-- 
error compiling committee.c: too many arguments to function

