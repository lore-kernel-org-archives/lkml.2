Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab1IAQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:37:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1IAQhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:37:19 -0400
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 01 Sep 2011 18:37:06 +0200
In-Reply-To: <20110901141219.GA13447@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
	 <20110419102600.GU31407@erda.amd.com> <1305753398.2466.7180.camel@twins>
	 <20110518212054.GC28476@elte.hu> <1305754613.2466.7190.camel@twins>
	 <20110519180650.GC6139@elte.hu> <20110520031855.GA17196@erda.amd.com>
	 <1314881807.11566.23.camel@twins> <20110901141219.GA13447@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314895026.1485.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 16:12 +0200, Robert Richter wrote:
> Will try to post an updated version
> next week. Ok?
> 
Sure.. thanks!
