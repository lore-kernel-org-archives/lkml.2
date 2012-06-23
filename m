Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2FWNmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:42:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2FWNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:42:20 -0400
X-Authority-Analysis: v=2.0 cv=cIliQyiN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=64DtJGphTH8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D85AHddHulbEpqEgNDIA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340458937.27036.291.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 2/3] Oops during Init IRQ
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        leroy christophe <christophe.leroy@c-s.fr>
Date: Sat, 23 Jun 2012 09:42:17 -0400
In-Reply-To: <alpine.LFD.2.02.1206231257560.2853@ionos>
References: <20120623030548.500374594@goodmis.org>
	 <20120623030639.113614886@goodmis.org>
	 <alpine.LFD.2.02.1206231257560.2853@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 12:59 +0200, Thomas Gleixner wrote:
> On Fri, 22 Jun 2012, Steven Rostedt wrote:
> 
> You asked for a changelog. Here you go:
> 
> Subject: powerpc: Mark low level irq handlers NO_THREAD
> 
> These low level handlers cannot be threaded. Mark them NO_THREAD
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Thanks! I'll add this when I commit it into the git tree.

-- Steve


