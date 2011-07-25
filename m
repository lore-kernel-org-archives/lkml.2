Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1GYIzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:55:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1GYIzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:55:38 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAOJsxLEg16wEJ69x0HeCXhD-U26vD8t5Uqj2OJvaCM-xhrQBzQ@mail.gmail.com>
Date: Mon, 25 Jul 2011 10:55:13 +0200
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <7A93237F-CC6D-4536-81CD-3580718D5C1D@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com> <ECCD7C67-C339-43EA-8A57-513173899813@suse.de> <CAOJsxLEmsSAHvKSX-Et0Q7cq+RgvgfuspWB3GamaBN-fRDq_mw@mail.gmail.com> <42789999-04D6-4709-80F8-55FAC3ECA6AC@suse.de> <CAOJsxLEg16wEJ69x0HeCXhD-U26vD8t5Uqj2OJvaCM-xhrQBzQ@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 10:51, Pekka Enberg wrote:

> On Mon, Jul 25, 2011 at 11:44 AM, Alexander Graf <agraf@suse.de> wrote:
>>> For the same reasons we want tools/perf to be there.
>> 
>> Yeah, I want a pony too.
> 
> I can contact the Linux Foundation to see if we can arrange that.
> 
> Seriously, though, I don't understand your point. What is it? Do you
> not agree that perf benefited from being part of the Linux kernel
> tree? Or do you think it does not apply here?

I disagree with the assumption that putting something into the kernel tree benefits the project (except for maybe bumping its visibility, so it potentially kills competition again). If however it's true, then we should analyze why exactly projects benefit from being in the kernel tree, so we can maybe find a good solution to achieve the same differently.

The approach "let's move everyting into tools/" simply doesn't scale.


Alex

