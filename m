Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1HHL7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:59:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1HHL7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:59:42 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 13:59:20 +0200
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309768420.3282.8.camel@twins> <1309769066.3282.14.camel@twins>
	 <1309867418.3282.73.camel@twins>
	 <20110705230217.GA9584@bloggs.ozlabs.ibm.com>
	 <1309960718.3282.289.camel@twins>  <20110708171836.6465a12e@kryten>
	 <1310138308.3282.708.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312804760.10488.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 13:57 +0200, Peter Zijlstra wrote:
> 
> Anton, Paul, any word on this? I'd love to see the specs for that
> power-pmu event vector thing.. It would be a terrible shame if we now
> include an abstraction that somewhat matches your needs but not quite,
> requiring us to either introduce another abi component later or. 

not context switch and get confused about the email you were
writing... :-)

I think I wanted to say something about trying to version the ABI, which
is pretty much the same anyway, a royal pain in the butt ;-)
