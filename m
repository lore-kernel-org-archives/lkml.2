Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1GCSEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 14:04:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:58220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1GCSEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 14:04:45 -0400
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110703150430.GV4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 03 Jul 2011 20:04:31 +0200
Message-ID: <1309716271.3282.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-03 at 17:04 +0200, Robert Richter wrote:
> 
> this is a prototype implementation for attaching an event to a
> specific PMU. If there is a general acceptance for this approach I
> will create patches for upstream integration and base my current IBS
> patches on it. 

But there's already an infrastructure to do this, simply stick the
contents of /sys/bus/event_source/devices/*/type in
perf_event_attr::type and you're done.

I don't see the need for /dev crap.
