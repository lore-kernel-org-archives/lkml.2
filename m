Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2ILOo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:44:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:53776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2ILOo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:44:27 -0400
Message-ID: <1347461060.15764.44.camel@twins>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 12 Sep 2012 16:44:20 +0200
In-Reply-To: <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-3-git-send-email-eranian@google.com>
	 <1347459764.15764.32.camel@twins>
	 <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:43 +0200, Stephane Eranian wrote:
> The hrtimer_active is used to prevent activating the timer multiple times
> in a row. 

see hrtimer_active(), this should do what you want I think.
