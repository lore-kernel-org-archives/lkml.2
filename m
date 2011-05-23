Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1EWPbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:31:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:56909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1EWPbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:31:00 -0400
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTimNhkdu_QcJqPjV5QLW8+G8E54jww@mail.gmail.com>
References: <20110520143707.GA5347@quad> <1306141897.18455.8.camel@twins>
	 <1306143168.18455.10.camel@twins>
	 <BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
	 <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
	 <1306149026.18455.11.camel@twins>
	 <BANLkTik5v7WGygmZqjbh6_iwJ35S9upReg@mail.gmail.com>
	 <1306163700.18455.16.camel@twins>
	 <BANLkTimNhkdu_QcJqPjV5QLW8+G8E54jww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 17:30:29 +0200
Message-ID: <1306164629.18455.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 17:27 +0200, Stephane Eranian wrote:
> Ok, my fault. That's because I tweaked your patch a bit and
> I did not keep track of idx. 

AH! Ok, at least its not my brain that's broken, was starting to doubt
my sanity there for a moment ;-)

> I guess the logic is not obvious.
> I think you should rename idx to orig_idx.

Indeed, that would clarify things.

Thanks!
