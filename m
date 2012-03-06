Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031422Ab2CFWUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:20:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab2CFWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:20:36 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=IzHinK49a2wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Q2wTnp8POpSdTfceFmwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331072433.25686.401.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 00/25][RFC 3.0.23-rt39-rc1] [ANNOUNCE]
 3.0.23-rt39-rc1 release cycle
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 06 Mar 2012 17:20:33 -0500
In-Reply-To: <20120306161636.491172179@goodmis.org>
References: <20120306161636.491172179@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 11:16 -0500, Steven Rostedt wrote:

> 
> Changes from 3.0.23-rt38:
> 
> ---
> 
> 
> Andy Lutomirski (2):
>       x86-64-remove-vsyscall-number-3
>       x86-64-emulate-legacy-vsyscalls
> 
> Steven Rostedt (11):
>       revert-convert-xtime_lock-to-raw_seqlock
>       revert-seqlock-create-raw_seqlock
>       revert-seqlock-use-seqcount
>       revert-seqlock-remove-unused-functions

Note, in order to apply Thomas's seqlock patches, I had to revert 4 -rt
patches, and apply two (Andy's) patches from mainline.

-- Steve




