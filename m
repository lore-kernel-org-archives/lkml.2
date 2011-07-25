Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1GYMre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:47:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1GYMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:47:28 -0400
Message-ID: <4E2D65AE.2020000@redhat.com>
Date: Mon, 25 Jul 2011 15:46:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Kevin Wolf <kwolf@redhat.com>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>	 <4E2CA6DE.4040900@web.de>	 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>	 <20110725075305.GA32294@elte.hu>	 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>	 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>	 <4E2D608F.6020606@redhat.com> <1311597712.14203.28.camel@jaguar>
In-Reply-To: <1311597712.14203.28.camel@jaguar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 03:41 PM, Pekka Enberg wrote:
> On Mon, 2011-07-25 at 14:24 +0200, Kevin Wolf wrote:
> >  So, as always, which set of command line switches works better for you
> >  depends entirely on your use case.
>
> I actually don't agree. I think Qemu requires way too much configuration
> from the user and doesn't try hard enough to provide best possible
> defaults.

qemu has a huge wealth of options so the command line is incredibly 
complicated.  Changing defaults is hard due to backward compatibility 
constraints.

> Dunno how much virt-manager changes all that, though.

virt-manager is a GUI interface, no command line at all.

-- 
error compiling committee.c: too many arguments to function

