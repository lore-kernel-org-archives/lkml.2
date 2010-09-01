Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0IAJfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:35:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:55661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0IAJfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:35:11 -0400
Subject: Re: ftrace/perf_event leak
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7E1C36.6070400@redhat.com>
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop>
	 <4C7E1C36.6070400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 11:35:02 +0200
Message-ID: <1283333702.2059.841.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 12:26 +0300, Avi Kivity wrote:
> On 09/01/2010 12:04 PM, Peter Zijlstra wrote:
> >
> > Does something like the below cure that?
> >
> 
> Unfortunately not.

Hrmm,.. bugger, don't use modules is my motto.. still I'll have another
look.
