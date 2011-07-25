Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab1GYJqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:46:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYJqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:46:46 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110725094136.GE28787@elte.hu>
Date: Mon, 25 Jul 2011 11:46:42 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <AB20F4B6-2A48-4245-9652-E1AE33C7DD29@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <20110725085426.GA28787@elte.hu> <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de> <20110725094136.GE28787@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 11:41, Ingo Molnar wrote:

>>> Virtualization is very tightly bound to the kernel, like it or 
>>> not. So is profiling, power management and a few other things.
> 
> It's a very simple point and observation: tools which integrate to 
> the kernel so that they wouldnt even run on another kernel obviously 
> are very natural to develop in tools/.

Ah, very good. So all we need to do to prove the point that kvm-tool doesn't belong in tools/ is port KVM to another OS and make kvm-tool compile there too? Shouldn't be too hard. People already have working ports of (old) KVM versions on FreeBSD and Windows.


Alex

