Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2BVOZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:25:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab2BVOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:25:37 -0500
Message-ID: <4F44FABF.1020401@redhat.com>
Date: Wed, 22 Feb 2012 12:25:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com> <20120221141231.GA15515@aftab> <1329835698.25686.60.camel@gandalf.stny.rr.com> <20120221145943.GB15515@aftab> <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com> <20120222104324.GA26845@aftab> <4F44D948.3000205@redhat.com> <20120222122555.GD26845@aftab> <4F44EE60.8030400@redhat.com> <20120222140526.GE26845@aftab>
In-Reply-To: <20120222140526.GE26845@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-02-2012 12:05, Borislav Petkov escreveu:
> On Wed, Feb 22, 2012 at 11:32:16AM -0200, Mauro Carvalho Chehab wrote:
> 
>> So, in other words, I think that the _best_ way to represent an MCA
>> type of error is to use an event with the following prototype:
> 
> No, it's not.

Why? It fits with all existing edac drivers, and it seems to fit with
mce_amd, based on the examples you gave.

> 
> And if you're going to repeat yourself for the 100th time as to why,
> don't even bother replying.

Well, a single string is not ok, as it is not easily parseable and it
doesn't allow to use the perf filters.

We need to agree on some trace format that fits, and that covers the
needs by the existing drivers.

I'm ok, if you didn't like the format I've proposed, if you have
a better proposal.

Regards,
Mauro.
