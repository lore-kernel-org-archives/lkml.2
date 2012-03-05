Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082Ab2CEUgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:36:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2CEUgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:36:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.191.163 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330979254.2191.98.camel@work-vm>
References: <20120305154411.GA29668@redhat.com> <1330972323.2191.74.camel@work-vm>
 <20120305192338.GA30491@redhat.com> <1330977010.2191.84.camel@work-vm>
 <20120305195758.GA25498@redhat.com> <CA+1xoqfYbC30dFDOtfAVcr5w0WYAS1ruKFS-rcRAEv2ZqaGW6w@mail.gmail.com>
 <1330979254.2191.98.camel@work-vm>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 5 Mar 2012 22:36:25 +0200
Message-ID: <CA+1xoqeKMVzSEMef+Yg6yBSyObN4pWA9cVf7t72SBJ0W==MNqQ@mail.gmail.com>
Subject: Re: WARNING: Adjusting tsc more then 11%
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Jones <davej@redhat.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:27 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Mon, 2012-03-05 at 22:16 +0200, Sasha Levin wrote:
>> On Mon, Mar 5, 2012 at 9:57 PM, Dave Jones <davej@redhat.com> wrote:
>> > On Mon, Mar 05, 2012 at 11:50:10AM -0800, John Stultz wrote:
>> >
>> >  > So it would be great to get further feedback from folks who are seeing
>> >  > this warning, so we can really hammer this out, but I don't want the
>> >  > warning spooking anyone into thinking things are terribly broken.
>> >
>> > One of the reports was from someone using vbox. I'm now wondering if
>> > the other users are using some other flavour of virt. I'll ask.
>>
>> I've reported this issue with regards to KVM before
>> (http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/85632) but
>> according to this thread it's not really KVM specific.
>>
>> It's easily reproducible using Dave's trinity running inside a KVM guest.
>
> Great! Do you have a link to trinity? (Google just gives me a video of
> its use and links to various churches)

Sure, the git tree is here: codemonkey.org.uk/projects/trinity/trinity.git

Basically just start 2*vcpu instances of trinity inside the guest and
wait a bit.
