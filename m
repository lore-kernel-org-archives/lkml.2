Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab2C2RwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:52:15 -0400
Received: from fifo99.com ([67.223.236.141]:45260 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab2C2RwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:52:10 -0400
Date: Thu, 29 Mar 2012 10:52:10 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329175209.GE16476@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
 <20120329145055.GE13912@fifo99.com>
 <4F748CF6.4010205@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F748CF6.4010205@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 09:25:26AM -0700, Tim Bird wrote:
> At the moment, I'm not considering an alternative for logger that runs
> completely in user-space.  Having said that, this test is certainly interesting,
> and may provide some performance numbers for logger or alternatives that would
> be useful to compare.


I was just thinking what does an accurate PID actually get you? If you
looking at some logs with a PID of 20048, does that mean something to
you? It doesn't actually mean much because you can't map that back to
anything. If you have the device, and the process is still running then
you could look it up ..

So lets say logger was modified to record comm values.. That way you
could record the actual process name AND the pid. Well if you use
prctl(PR_SET_NAME), you can forge comm values. So that doesn't get you
much either..

So even if you record accurate PID values, it doesn't mean anything
anyway.

Daniel
