Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2HMNBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:01:21 -0400
Received: from canardo.mork.no ([148.122.252.1]:55054 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2HMNBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:01:20 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: KY Srinivasan <kys@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: hv: use Linux version in guest ID
Organization: m
References: <87fw8mlv7e.fsf@nemi.mork.no>
	<1342771388-24389-1-git-send-email-bjorn@mork.no>
	<20120720152650.GA5201@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF923547836@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20120720160953.GA5802@kroah.com>
Date: Mon, 13 Aug 2012 15:00:28 +0200
In-Reply-To: <20120720160953.GA5802@kroah.com> (Greg KH's message of "Fri, 20
	Jul 2012 09:09:53 -0700")
Message-ID: <87fw7rhrpv.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Fri, Jul 20, 2012 at 04:02:44PM +0000, KY Srinivasan wrote:
>> > On Fri, Jul 20, 2012 at 10:03:08AM +0200, Bjørn Mork wrote:
>> >
>> > > +/* Linux vendor ID allocated by Microsoft */
>> > > +#define HV_LINUX_GUEST_ID_VENDOR	0xB16B
>> > > +
>> > > +/* Creating a guest ID conforming to the encoding recommended by
>> > > + * Microsoft, with variant and build fixed to 0
>> > 
>> > We could use the kernel build number here as well, if we really wanted
>> > it, right?

Yes, we could.  I just didn't see any value it that. Why would you want
your hypervisor to care about some arbitrary build number?

But it can of course be added if anyone needs it.

>> > Otherwise, I like this patch, KY, any objection to me taking it?
>> 
>> Greg,
>> 
>> If it is ok with you can we wait a couple of days. I am pushing to get information
>> back from folks within MSFT. I am hoping  we can fix this issue soon.
>
> Ok, I'll hold on to it for a week or so.

Not to nag or anything like that, but ... It's been a week or so now,
hasn't it? :-)


Bjørn
