Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1ADMoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:44:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39229 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1ADMoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UP38rhMi6OAu2gfrVloXpB4pOGIMP6S2rFAGphMBM2h0dkojJRCuK9xoQC8F+Nu0Uj
         Jpjl+3FCo3BMaGPQ+8J/YV9Y68ZBWboIP7L9lQeovyBkWszCHwq7cltZsjqrqet1wIvw
         fpX8YBgGq0cC6ZGosqrMfrWYLucAbAsbZwC3Y=
MIME-Version: 1.0
In-Reply-To: <4D2158C4.5010107@redhat.com>
References: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>
	<4D20B38B.40007@redhat.com>
	<AANLkTi=hKcX5Sjei-gNjkknU9O4bZ=bxT9AuSA-US-H4@mail.gmail.com>
	<4D2158C4.5010107@redhat.com>
Date: Tue, 4 Jan 2011 20:44:11 +0800
Message-ID: <AANLkTikjdyc+B7rNWrvjfdPhcbR5ECiFgUfZpObb_42V@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Edwin Zhai <edwin.zhai@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 1:04 PM, Rik van Riel <riel@redhat.com> wrote:
> On 01/02/2011 11:18 PM, Hillf Danton wrote:
>>
>> On Mon, Jan 3, 2011 at 1:19 AM, Rik van Riel<riel@redhat.com>  wrote:
>>>
>>> On 01/02/2011 06:43 AM, Hillf Danton wrote:
>>>
>>>> The following work is based on what Rik posted, with a few changes.
>>>
>>> I threw out my patch before Christmas, replacing it with
>>> Mike Galbraith's work.
>>>
>>
>> Would you please share the work by Mike, or info where to get it?
>
> Now that I finally got useful test results (after
> increasing ple_gap to be more useful on the X5670
> CPU), I will post the patch series.
>

Good news after holiday!

> Christmas holidays are a good thing, but expect
> patches tomorrow :)
>

Please then get me Cced when posting :)

Hillf
