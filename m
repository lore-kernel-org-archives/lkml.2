Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0FDJsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:48:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:36471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0FDJsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:48:13 -0400
Subject: Re: perf: tools/perf/design.txt is badly out of date
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <4C083D2C.5070204@linux.vnet.ibm.com>
References: <4C083D2C.5070204@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 11:48:28 +0200
Message-ID: <1275644908.27810.39476.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 16:39 -0700, Corey Ashford wrote:
> I had a glance at tools/perf/design.txt the other day, and it
> appears to be pretty far out of date.
> 
> Is design.txt a document that you want to keep the current way for
> historical reasons [and the up-to-date documentation placed somewhere
> else], or one that should be maintained?
> 
> I'm wondering if some/all of this documentation should move into
> include/linux/perf_event.h

Its the ineffiteble fate of everything Documentation/ to be out-dated.
But yeah, that file will be woefully inaccurate by now.

Yeah, I think making perf_event.h more explanatory would be good. But I
don't think we want to go overboard there either, if comments get too
large and unwieldy they tend to bitrot just as hard as Documentation/


