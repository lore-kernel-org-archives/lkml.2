Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2CNPOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:14:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2CNPOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:14:40 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=mPAfQOb7mL0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=vJ7kqOu9oBQ1AYStUT4A:9 a=cTIZWZ_8NEKN72llUIEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331738077.25686.668.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 0/7] [ANNOUNCE] 3.0.23-rt40-rc1
From: Steven Rostedt <rostedt@goodmis.org>
To: Karsten Wiese <fzuuzf@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 14 Mar 2012 11:14:37 -0400
In-Reply-To: <201203141352.10145.fzuuzf@googlemail.com>
References: <20120314022658.783312660@goodmis.org>
	 <201203141352.10145.fzuuzf@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 13:52 +0100, Karsten Wiese wrote:
> Am Mittwoch 14 März 2012 schrieb Steven Rostedt:
> 
> 
> > Changes from 3.0.23-rt39:
> > 
> > ---
> > 
> > 
> > Steven Rostedt (2):
> >       Revert "ACPI: Convert embedded controller lock to raw spinlock"
> >       Linux 3.0.23-rt40-rc1
> 
> 
> How about also reverting the commit that has changed acpi_gbl_gpe_lock to a
> raw spinlock?

Hmm, you're right, I missed that.

It's harder to find things removed from Thomas's series than it is to
add new stuff :-/

As I'm ready to push this, I'll do the removal after updating to 3.0.24.

-- Steve


