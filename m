Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0FCXj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:39:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60757 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab0FCXjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:39:24 -0400
Message-ID: <4C083D2C.5070204@linux.vnet.ibm.com>
Date: Thu, 03 Jun 2010 16:39:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: perf: tools/perf/design.txt is badly out of date
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a glance at tools/perf/design.txt the other day, and it
appears to be pretty far out of date.

Is design.txt a document that you want to keep the current way for
historical reasons [and the up-to-date documentation placed somewhere
else], or one that should be maintained?

I'm wondering if some/all of this documentation should move into
include/linux/perf_event.h

- Corey
