Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2DCXTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:19:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58274 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2DCXTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:19:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
	<20120403081735.78ca3bb3@pluto.restena.lu>
	<m1d37pgugy.fsf@fess.ebiederm.org> <20120403071543.GA17502@gmail.com>
	<m1r4w5dzjq.fsf@fess.ebiederm.org> <1333463264.2960.99.camel@laptop>
Date: Tue, 03 Apr 2012 16:22:46 -0700
In-Reply-To: <1333463264.2960.99.camel@laptop> (Peter Zijlstra's message of
	"Tue, 03 Apr 2012 16:27:44 +0200")
Message-ID: <m1aa2s2yex.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/4RY3ghC7agkGvgxr7YI297jSF5fxF1QM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, 2012-04-03 at 00:50 -0700, Eric W. Biederman wrote:
>> 
>> So I am asking that since perf is built in a way that actively makes
>> debugging these kinds of problems hard that you please add additional
>> debugging code to perf_pmu_register or some other better location so
>> that simply registering something buggy with perf will show the bug.
>> 
>> 
> Is there a convenient helper function that we can use that validates the
> attribute_group structure? We could use such a function to do the
> validation at a point where we still know where it came from.

There isn't but I was just thinking before you sent this that we could
really use one.

Eric
