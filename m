Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1JDI2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:28:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1JDI2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:28:21 -0400
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>
Date: Tue, 04 Oct 2011 10:27:19 +0200
In-Reply-To: <20110923122014.GP6063@erda.amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	 <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317716839.25926.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 14:20 +0200, Robert Richter wrote:
> > The only thing I'm not quite sure on is the userspace bits, but those
> > are in the future work section as well, but possibly Ingo has a strong
> > opinion here, sadly he doesn't have email atm :/
> 
> With Lin's patch 'perf: Remove perf_event_attr::type check' we already
> can sample with perf record.
> 
> I think we could extend perf report to parse also ibs samples. The
> only thing we need for it should be the pmu name/type mapping in the
> perf.data header and the pmu type in the sample. See my comment on
> Stephane's patch '[PATCH] perf: make perf.data more self-descriptive
> (v5)'. 

OK, so Ingo really really wants to see a little more perf integration
there. Acme, what's the state of Stephane's patch?
