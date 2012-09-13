Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2IMM3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:29:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:44265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab2IMM3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:29:19 -0400
Message-ID: <1347539352.7172.1.camel@twins>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 13 Sep 2012 14:29:12 +0200
In-Reply-To: <CABPqkBQr-nfwEdw_k5fZKrVUjyPYpSr_KQPoOsUp7ykcL4-QmA@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-3-git-send-email-eranian@google.com>
	 <1347459764.15764.32.camel@twins>
	 <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
	 <CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
	 <1347538571.15764.133.camel@twins>
	 <CABPqkBQO2fHoidvubDiL9AhCY-FZkk5_WGyPxerT1noH41R53w@mail.gmail.com>
	 <1347539180.7172.0.camel@twins>
	 <CABPqkBQr-nfwEdw_k5fZKrVUjyPYpSr_KQPoOsUp7ykcL4-QmA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 14:27 +0200, Stephane Eranian wrote:

> No because we should not use the patch I posted last week. So rotation_start()
> would still enqueue SW pmus.

Hrmm. I just send it to Ingo.. let me see if I can still recall that.
