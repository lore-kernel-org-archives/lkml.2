Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0IXS7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:59:14 -0400
Received: from cpe-67-242-120-143.stny.res.rr.com ([67.242.120.143]:53054 "EHLO
	localhost6.localdomain6" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757484Ab0IXS7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:59:13 -0400
X-Greylist: delayed 2984 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 14:59:12 EDT
Subject: Re: [tip:perf/core] jump label: x86 support
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <4C9CE01D.1060204@zytor.com>
References: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
	 <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org>
	 <4C9CCF98.7000506@zytor.com> <20100924163435.GE2887@redhat.com>
	 <4C9CE01D.1060204@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Sep 2010 14:08:50 -0400
Message-ID: <1285351730.2270.0.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 10:30 -0700, H. Peter Anvin wrote:
> On 09/24/2010 09:34 AM, Jason Baron wrote:
> > 
> > The !CC_OPTIMIZE_FOR_SIZE condition is subsequently removed by a
> > follow-on patch as part of the commit series.
> > 
> 
> Ah, okay.  No problem then.

Sorry, I should have Cc'd you on that patch.

-- Steve
