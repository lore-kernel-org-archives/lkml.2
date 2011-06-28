Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab1F1RVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:21:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab1F1RTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:19:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=OmeNMJaIUdL9gPqvKuQ0TlMDSJM6D6KzqQs/n648CCtyc6lzUc/frNmv0aG2MY4Pu
	R2uFK+o+t+tNs4qtjm4Lg==
MIME-Version: 1.0
In-Reply-To: <1309273180.6701.213.camel@twins>
References: <1308797024.23204.95.camel@debian> <1308819748.1022.69.camel@twins>
 <1308876099.23204.124.camel@debian> <1309219329.14604.11.camel@debian> <1309273180.6701.213.camel@twins>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 28 Jun 2011 10:13:24 -0700
Message-ID: <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
Subject: Re: power increase issue on light load
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Alex, Shi" <alex.shi@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 7:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-28 at 08:02 +0800, Alex,Shi wrote:
>> > >
>> > > What happens if you try something like the below. Increased imbalance
>> > > might lead to more load-balance action, which might lead to more task
>> > > migration/waking up of cpus etc.
>> > >
>> > > If the below makes any difference, Nikhil's changes have a funny that
>> > > needs to be caught.
>> >
>> > Yes, it most remove the commit effect, So the power recovered.
>> >
>> > In fact the only suspicious I found is large imbalance, but that is
>> > the commit want ...
>>
>> Any further comments for this?
>
> I had a look over all that stuff, but I couldn't find an obvious unit
> mis-match in any of the imbalance code. Nikhil any clue?
>

Sorry for the late reply. My mailbox filters failed me :-(

Alex -- I'm looking into this issue. Will get back to you soon.

-Thanks,
Nikhil
