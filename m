Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1GGAv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:51:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1GGAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:51:26 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=o4PvyO1M3v0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oGMlB6cnAAAA:8 a=aVy5HxTbUxGU44mv0GoA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 01/11] x86/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20110702033852.733414762@goodmis.org>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033852.733414762@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Jul 2011 20:51:22 -0400
Message-ID: <1309999882.26417.201.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 23:04 -0400, Steven Rostedt wrote:

> The simple solution is to just mark them as notrace. I had to add the
> <linux/types.h> for this file to include the notrace tag.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>

Ingo, Thomas or Peter,

Could one of you pull this patch into tip? It probably could still go
into the 3.0 release, as it's just adding notrace annotation and should
be very small chance to cause any regressions.

-- Steve


