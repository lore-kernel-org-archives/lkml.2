Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1DVUje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:39:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:48998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1DVUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:39:32 -0400
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Kleen, Andi" <andi.kleen@intel.com>
In-Reply-To: <BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	 <1303478798.2461.11.camel@localhost>
	 <BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 22:42:09 +0200
Message-ID: <1303504929.4865.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 15:46 +0200, Stephane Eranian wrote:
> 
> perf stat -e offcore_response_0:dmd_data_rd,offcore_response_0:dmnd_rfo ......
> 
> This should still not be allowed.

Aside from the problem you mention, I don't like the whole
offcore_response_[01] thing. The offcore things are fully symmetric so
the kernel should automatically select the other one if one is taken.



