Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1EWLMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:12:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1EWLMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:12:22 -0400
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
References: <20110520143707.GA5347@quad> <1306141897.18455.8.camel@twins>
	 <1306143168.18455.10.camel@twins>
	 <BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
	 <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 13:11:48 +0200
Message-ID: <1306149108.18455.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 12:58 +0200, Stephane Eranian wrote:
> >> event->hw.config &= ~X86_RAW_EVENT_MASK;
> 
> Not quite, you want INTEL_ARCH_EVENT_MASK instead
> because you only want to modify umask+event code. 

Do EDGE,INV,CMASK actually make a difference for the OFFCORE event?
