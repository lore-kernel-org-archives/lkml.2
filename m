Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1JSGpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:45:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1JSGpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:45:44 -0400
Date: Wed, 19 Oct 2011 08:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov,
        yrl.pp-manager.tt@hitachi.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] x86: Add a sanity test of x86 decoder
Message-ID: <20111019064401.GA2075@elte.hu>
References: <20111012070601.GC18618@elte.hu>
 <20111013110127.28099.19162.stgit@localhost.localdomain>
 <20111018065453.GL16304@elte.hu>
 <4E9E522C.9030505@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E522C.9030505@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> >> +static void dump_stream(FILE *fp, const char *msg, struct insn *insn)
> >> +{
> >> +	int i;
> >> +	fprintf(fp, "%s:\n code:", msg);
> > 
> > missing newline.
> 
> This prints a header of code sequence, so that we'll see a
> message like below;

I mean, it's missing the standard newline between local variable(s) 
and the first statement:

static void dump_stream(FILE *fp, const char *msg, struct insn *insn)
{
	int i;

	fprintf(fp, "%s:\n code:", msg);
[...]

We do this for readability.

Thanks,

	Ingo
