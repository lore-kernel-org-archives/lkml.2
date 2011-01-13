Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1AMRkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:40:52 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55469 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1AMRku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:40:50 -0500
Subject: Re: [PATCH 2/7] perf-events: Add support for supplementary event
 registers v4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        paulus <paulus@samba.org>
In-Reply-To: <AANLkTik9adcY_pH52c_Y0iRjitDKZOu5zyPusfjycuiH@mail.gmail.com>
References: <1293464165.2695.102.camel@localhost>
	 <AANLkTik9adcY_pH52c_Y0iRjitDKZOu5zyPusfjycuiH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Jan 2011 18:41:05 +0100
Message-ID: <1294940465.30950.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 18:31 +0100, Stephane Eranian wrote:
> In fact, given that the Sandy Bridge PMU spec is now available, we
> have a first example of this (see Vol3b figure 30.29). OFFCORE_RESPONSE
> needs 38 bits. So, instead of having NHM/WSM use attr->config and SNB
> use another field, I think it would make sense to have that in a new u64 field
> for all processors. Despite the fact that OFFCORE_RESPONSE remains
> a model-specific feature, I think it would help user tools and libraries if we
> were to use a dedicated field. 

Paul, iirc you talked about a u64 perf_event_attr::config2 way back, are
there any ppc features that want this too?
