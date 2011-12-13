Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1LMKDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:03:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:60683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LMKDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:03:21 -0500
Message-ID: <1323770542.9082.9.camel@twins>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES
 generic PMU event
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Date: Tue, 13 Dec 2011 11:02:22 +0100
In-Reply-To: <CABPqkBQJZNFC3cnXWz1ycnFDKqY6j9QeoMnq_zxH138e2Tt6kQ@mail.gmail.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	 <1323559734-3488-3-git-send-email-eranian@google.com>
	 <1323694657.13285.12.camel@twins> <20111212173215.GI23870@elte.hu>
	 <CABPqkBQJZNFC3cnXWz1ycnFDKqY6j9QeoMnq_zxH138e2Tt6kQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 22:45 -0800, Stephane Eranian wrote:

> Isn't CPU_REF_CYCLES good enough?

I was just asking.. someone needs to ;-)

Took the remaining patches as well, thanks!
