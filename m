Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1HCMTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:19:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42670 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1HCMTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:19:34 -0400
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110803121119.GC5768@somewhere.redhat.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
	 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
	 <1312369161.1147.292.camel@twins>
	 <20110803113706.GA5768@somewhere.redhat.com>
	 <1312371741.1147.301.camel@twins>
	 <20110803115703.GB5768@somewhere.redhat.com>
	 <1312373135.1147.308.camel@twins>
	 <20110803121119.GC5768@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 14:18:51 +0200
Message-ID: <1312373931.1147.314.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 14:11 +0200, Frederic Weisbecker wrote:
> Look at tools/perf/util/parse-events.c:parse_single_tracepoint_event()

fscking tinkerers.. that's horrid... strncmp("record") seriously wtf
were you smoking, Acme why did you ever merge crap like that?

Also, acme that can break stuff, remember the whole different
->sample_format discussion?

/me stomps off and goes do something useful, this userspace is like all
other userspace.. a steaming pile of shit.
