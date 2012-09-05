Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2IEJKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:10:02 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54374 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2IEJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:09:59 -0400
Message-ID: <5047161F.60503@parallels.com>
Date: Wed, 5 Sep 2012 13:06:39 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <davej@redhat.com>, <ben@decadent.org.uk>,
        <a.p.zijlstra@chello.nl>, <pjt@google.com>, <lennart@poettering.net>,
        <kay.sievers@vrfy.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
References: <1346768300-10282-1-git-send-email-glommer@parallels.com> <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com> <5047074D.1030104@parallels.com> <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com> <50470A87.1040701@parallels.com> <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com> <50470EBF.9070109@parallels.com> <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com> <50471379.3060603@parallels.com> <20120905090744.GG3195@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120905090744.GG3195@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 01:07 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Sep 05, 2012 at 12:55:21PM +0400, Glauber Costa wrote:
>>> So, I think it's desirable for all controllers to be able to handle
>>> hierarchies the same way and to have the ability to tag something as
>>> belonging to certain group in the hierarchy for all controllers but I
>>> don't think it's desirable or feasible to require all of them to
>>> follow exactly the same grouping at all levels.
>>
>> By "different levels of granularity" do you mean having just a subset of
>> them turned on at a particular place?
> 
> Heh, this is tricky to describe and I'm not really following what you
> mean. 

Do we really want to start cleaning up all this by changing the
interface to something that is described as "tricky" ?


