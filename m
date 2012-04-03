Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2DCO2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:28:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2DCO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:28:03 -0400
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
From: Peter Zijlstra <peterz@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <m1r4w5dzjq.fsf@fess.ebiederm.org>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	 <20120402165036.2bc987ad@pluto.restena.lu>
	 <m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
	 <1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	 <20120403060252.GA27084@gmail.com>
	 <20120403081735.78ca3bb3@pluto.restena.lu>
	 <m1d37pgugy.fsf@fess.ebiederm.org> <20120403071543.GA17502@gmail.com>
	 <m1r4w5dzjq.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 16:27:44 +0200
Message-ID: <1333463264.2960.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 00:50 -0700, Eric W. Biederman wrote:
> 
> So I am asking that since perf is built in a way that actively makes
> debugging these kinds of problems hard that you please add additional
> debugging code to perf_pmu_register or some other better location so
> that simply registering something buggy with perf will show the bug.
> 
> 
Is there a convenient helper function that we can use that validates the
attribute_group structure? We could use such a function to do the
validation at a point where we still know where it came from.

