Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1HCTug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:50:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:36426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab1HCTua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:50:30 -0400
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110803170627.GB29321@ghostprotocols.net>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
	 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
	 <1312369161.1147.292.camel@twins>
	 <20110803113706.GA5768@somewhere.redhat.com>
	 <1312371741.1147.301.camel@twins>
	 <20110803115703.GB5768@somewhere.redhat.com>
	 <1312373135.1147.308.camel@twins>
	 <20110803121119.GC5768@somewhere.redhat.com>
	 <1312373931.1147.314.camel@twins>
	 <20110803170627.GB29321@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 21:49:47 +0200
Message-ID: <1312400988.1147.324.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 14:06 -0300, Arnaldo Carvalho de Melo wrote:
> 
> > /me stomps off and goes do something useful, this userspace is like all
> > other userspace.. a steaming pile of shit.
> 
> Nah, its all code, no matter what side of the fence. 

Yeah, I know, I'm overly grumpy at times, more so of late. Sorry about
that.
