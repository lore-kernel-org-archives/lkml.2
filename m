Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2C0Dvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:51:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62221 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2C0Dvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1332783932.12799.16.camel@acer.local.home>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	<1332531400.23924.71.camel@gandalf.stny.rr.com>
	<CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
	<1332597305.12799.2.camel@acer.local.home>
	<1332783932.12799.16.camel@acer.local.home>
Date: Tue, 27 Mar 2012 09:21:51 +0530
Message-ID: <CA+jqyFD7bq1jSNG9QV+iQx-PGsOmjSAyzo-pjLFau96ei=xNGA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thanks for your feedback.
I will work on the V2 of this patch to get the mentioned issue resolved.

- Rajesh


On Mon, Mar 26, 2012 at 11:15 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2012-03-24 at 09:55 -0400, Steven Rostedt wrote:
>
>> That said, I may consider taking the patch, as another way of resetting
>> the tracer. I have to see what workflows it will affect first.
>
> This is what I was afraid of. The tracers irqsoff and preemptoff do not
> get reset if you echo the tracer name into the current_tracer. This
> makes different tracers inconsistent.
>
> All tracers must act the same. So, it's a no go for this patch, at least
> in its current form.
>
> -- Steve
>
>
