Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1DGOjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:39:05 -0400
Received: from mail.digium.com ([216.207.245.2]:46054 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1DGOjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:39:04 -0400
Date: Thu, 7 Apr 2011 09:38:58 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>, Don Zickus <dzickus@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
	proper MSR register to catch" and NMIs
Message-ID: <20110407143858.GA18616@digium.com>
References: <20110406223036.GA15721@digium.com> <20110407001658.GW12642@redhat.com> <BANLkTi=W45VbeBNThBqKv2Wbo+8sWxXjuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <BANLkTi=W45VbeBNThBqKv2Wbo+8sWxXjuA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 07:18:50AM +0400, Cyrill Gorcunov wrote:
> On Thursday, April 7, 2011, Don Zickus <dzickus@redhat.com> wrote:
>> On Wed, Apr 06, 2011 at 05:30:36PM -0500, Shaun Ruffell wrote:
>>>
>>> I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
>>> certain where to go from here.  Is this something that is already known
>>> or is there more information I should try to collect?
>>
>> Nope, this is an ongoing issue.  What happened was the perf P4 nmi handler
>> was swallowing all the NMIs.  My patch fixed that and exposed a double NMI
>> problem.  We have been chasing it for a couple of months.  I think Cyril
>> was finally able to duplicate it (as he wrote the P4 code).  I have
>> confidence that he will find a fix for it soon. :-)
>>
>> Thanks for the report though!
> 
> Hi, yeah, i got it too and i hope to fix this issue soon. Will ping as
> only get working fix.

Don, Cyrill,

Thanks for the explanation and my apologies for not relating the
previous discussions about this to what I was seeing. This issue would
be a blocker for any 2.6.39 final right?

Cyrill, I would be more than happy to test any patches. It's relatively
quick for me to reproduce.

Thanks,
Shaun
