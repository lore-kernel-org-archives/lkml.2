Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0IQW1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:27:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab0IQW1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:27:14 -0400
From: Thomas Renninger <trenn@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Sat, 18 Sep 2010 00:26:58 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009171736.14170.trenn@suse.de> <20100917162412.GB3341@elte.hu>
In-Reply-To: <20100917162412.GB3341@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009180026.59482.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010 18:24:12 Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > On Friday 17 September 2010 16:24:59 Ingo Molnar wrote:

> [ You dont even have to document it, as good code is self-explanatory ;-) ]
I recently posted a patch exporting some things through /sys/kernel/debug/...
Greg complained that a file for Documentation/ABI/{testing,stable}/* is missing
and I fully agree.
If different userspace apps should make use of this (in above case nobody
than my debug userspace tool will...) and this should be called something like an API,
it should be documented and if something changes, it should
first be marked deprecated, etc.

     Thomas
