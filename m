Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GYIXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:23:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57735 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1GYIXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CA6DE.4040900@web.de>
	<CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	<20110725075305.GA32294@elte.hu>
	<0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
Date: Mon, 25 Jul 2011 11:23:43 +0300
X-Google-Sender-Auth: 9KcV02u3Lb2aXRXYNM4Flg3mJSU
Message-ID: <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Jul 25, 2011 at 11:14 AM, Alexander Graf <agraf@suse.de> wrote:
>> Same here - in fact i first asked Qemu to be put into tools/qemu/ so
>> that it all becomes more hackable and more usable - that suggestion
>> was rebuked very strongly.
>
> So instead of thinking a bit and trying to realize that there might be a reason people don't want all their user space in the kernel tree you go ahead and start your own crusade of creating a new user space. Great. That's how I always hoped Linux would be :(.

Damn you Ingo Molnar, I knew you'd somehow get all the credit for our
hard work! ;-)

More seriously, though, I fail to see what's bothering you Alexander.
I and Ingo already mentioned we wouldn't be hacking on Qemu even if
there wasn't no tools/kvm. It's not as if we're putting *your* user
space code into the kernel tree - we wrote our own! What's wrong with
that?

                        Pekka
