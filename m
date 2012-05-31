Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2EaOW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:22:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2EaOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:22:56 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uCChaeT6IvQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=CjastpgQm507VLERPU0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338474158.13348.346.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/3] uprobes/core: Remove redundant lock_page/unlock_page
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Thu, 31 May 2012 10:22:38 -0400
In-Reply-To: <1338465518.28384.55.camel@twins>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
	 <1338465518.28384.55.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:58 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-31 at 17:16 +0530, Srikar Dronamraju wrote:
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > No need to lock the page when copying the opcode in read_opcode().
> 
> It would be good if the changelog said _why_ this is so :-)

I thought the same thing when I read it.

-- Steve


