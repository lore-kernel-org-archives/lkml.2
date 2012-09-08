Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2IHNgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 09:36:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38550 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2IHNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 09:36:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31RKVYpkc0oTJKjsdsvqBfif=Bovi3a6TE8qdOOpEYOC0Lw@mail.gmail.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
	<5047074D.1030104@parallels.com>
	<20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50470A87.1040701@parallels.com>
	<20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50470EBF.9070109@parallels.com>
	<20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<1346835993.2600.9.camel@twins>
	<20120905093204.GL3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<1346839487.2600.24.camel@twins>
	<20120906204642.GN29092@google.com>
	<CAPM31RKVYpkc0oTJKjsdsvqBfif=Bovi3a6TE8qdOOpEYOC0Lw@mail.gmail.com>
Date: Sat, 8 Sep 2012 09:36:29 -0400
Message-ID: <CAPhKKr8f6q=6m4T=-6PA8za-nMQMKy1HykAX-2NRaL9AZoPSjw@mail.gmail.com>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 5:11 PM, Paul Turner <pjt@google.com> wrote:
> On Thu, Sep 6, 2012 at 1:46 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> cc'ing Dhaval and Frederic.  They were interested in the subject
>> before and Dhaval was pretty vocal about cpuacct having a separate
>> hierarchy (or at least granularity).
>
> Really?  Time just has _not_ borne out this use-case.  I'll let Dhaval
> make a case for this but he should expect violent objection.
>

I am not objecting directly! I am aware of a few users who are (or at
least were) using cpu and cpuacct separately because they want to be
able to account without control. Having said that, there are tons of
flaws in the current approach, because the accounting without control
is just plain wrong. I have copied a few other folks who might be able
to shed light on those users and if we should still consider them.

[And the lesser number of controllers, the better it is!]

Thanks!
Dhaval
