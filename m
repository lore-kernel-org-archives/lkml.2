Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0KZNGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:06:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:35870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0KZNGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:06:41 -0500
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com
In-Reply-To: <AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
References: <20101123224601.766827604@openvz.org>
	 <20101123224800.294919307@openvz.org>
	 <AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com>
	 <AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com>
	 <AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
	 <AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
	 <AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com>
	 <AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com>
	 <AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 14:06:47 +0100
Message-ID: <1290776807.2145.144.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 16:04 +0300, Cyrill Gorcunov wrote:
> if none therad is active, single any
> thread is active, both threads are active and finally any thread is
> active (which is exactly 0b11 in single thread machine). i know it's
> weird ;)
> 
BTW, does P4 mandate SYS_CAP_ADMIN for counting another thread's events?


