Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0DOHoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:44:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:38040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0DOHoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:44:23 -0400
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:44:21 +0200
Message-ID: <1271317461.32749.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
> This patch series introduces model specific events and impments AMD
> IBS (Instruction Based Sampling) for perf_events.

I would much rather it uses the ->precise thing PEBS also uses,
otherwise we keep growing funny arch extensions and end up with a
totally fragmented trainwreck of an ABI.

> The general approach is to introduce a flag to mark an event as model
> specific. With that flag set a model specific ibs (raw) config value
> can be passed to the pmu for setup. When there are ibs samples
> available, it is sent back as a raw data sample to the userland. So we
> have a raw config value and raw sampling data. This requires the
> userland to setup ibs and further extract and process sampling data.
> 
> Patches 1-8 rework and refactor the code to prepare the ibs
> implementation. This is done in patches 9-12.
> 
> I will add ibs example code to libpfm4.

Please add a valid usecase to tools/perf/ instead.

