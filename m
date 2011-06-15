Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1FOP2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:28:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab1FOP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:28:13 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=Z275A97WDy8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=1v-G_syCxuTq9GUsZDUA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86: Change trap definitions to enumerated values
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Aditya Kali <adityakali@google.com>
In-Reply-To: <BANLkTimNs-iJPK67fkWdeq_Hmd2WvPSFpo9-ZL4hHOobkXaZNg@mail.gmail.com>
References: <1304462995-1825-1-git-send-email-vnagarnaik@google.com>
	 <BANLkTimNs-iJPK67fkWdeq_Hmd2WvPSFpo9-ZL4hHOobkXaZNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Jun 2011 11:28:11 -0400
Message-ID: <1308151691.9218.128.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 16:29 -0700, Vaibhav Nagarnaik wrote:
> On Tue, May 3, 2011 at 3:49 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
> > From: Aditya Kali <adityakali@google.com>
> >
> > The traps are referred to by their numbers and it can be difficult to
> > understand them while reading the code without context. This patch adds
> > enumeration of the trap numbers and replaced the numbers to the correct
> > enum for x86.
> >
> > Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> >

> All
> 
> Can you please go through this patch?

This is very x86 specific and needs to be handled by the x86
maintainers.

Thomas, Ingo ?

-- Steve


