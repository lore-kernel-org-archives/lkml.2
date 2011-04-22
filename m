Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1DVOpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 10:45:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1DVOpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 10:45:23 -0400
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Kleen, Andi" <andi.kleen@intel.com>
In-Reply-To: <BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	 <1303478798.2461.11.camel@localhost>
	 <BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
	 <1303482702.2461.40.camel@localhost>
	 <BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 16:47:58 +0200
Message-ID: <1303483678.4865.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 16:41 +0200, Stephane Eranian wrote:
> I assume that's because hotplug
> cpu is inherently serialized. You cannot have a CPU going offline
> and one going online at the same time. is that right? 

Exactly, that's all serialized under the hotpug mutex

