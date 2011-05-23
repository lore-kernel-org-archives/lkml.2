Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1EWPSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:18:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1EWPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:18:07 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=t-xHGFQvy1cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=IMppI3Ua0ncSiLxUA48A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/6] ktest: Reboot to good kernel after every bisect run
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTimtR=_X=4hWgagtRiawHH_59V7PVQ@mail.gmail.com>
References: <20110523135120.309567301@goodmis.org>
	 <20110523135314.896139545@goodmis.org>
	 <BANLkTimtR=_X=4hWgagtRiawHH_59V7PVQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 23 May 2011 11:18:04 -0400
Message-ID: <1306163884.1465.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 17:04 +0200, John Kacur wrote:
> On Mon, May 23, 2011 at 3:51 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Reboot after each bisect run regardless if the bisect passed
> > or failed. The test may just be to boot the kernel and that kernel
> > may not have a way to copy the next kerne to it. Reboot to a known
> > good kernel after each bisect run.
> >
> 
> How about an option to not reboot for good kernels?

Would be trivial to add. But that would be for 2.6.41.

Thanks,

-- Steve


