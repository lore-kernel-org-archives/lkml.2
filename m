Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1IMDoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:44:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41772 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1IMDoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:44:12 -0400
Subject: Re: [PATCH 10/24] C6X: time management
From: john stultz <johnstul@us.ibm.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1315883885.11280.34.camel@deneb.redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-11-git-send-email-msalter@redhat.com>
	 <CANcMJZBxCQFgAsO89X+_SSm02vtseRhY7ozoxik4UMEuJUdDNQ@mail.gmail.com>
	 <1315883885.11280.34.camel@deneb.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 20:44:02 -0700
Message-ID: <1315885442.3180.86.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11091303-2398-0000-0000-0000002BF149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 23:18 -0400, Mark Salter wrote:
> On Mon, 2011-09-12 at 18:16 -0700, john stultz wrote:
> > On Wed, Aug 31, 2011 at 2:26 PM, Mark Salter <msalter@redhat.com> wrote:
> > > The C6X architecture includes a 64-bit free running core clock counter which
> > > is used as the clocksource. The SoCs have a number of 64-bit programmable
> > > timers. One of these is used as the clockevent timer.
> > >
> > > Signed-off-by: Mark Salter <msalter@redhat.com>
> > 
> > Sort of a tangent to this specific patch, but since it came up
> > recently in the x32 discussion, I wanted to check if you were using a
> > 64bit definition of time_t?
> 
> C6X uses the asm-generic definition which is a long, so 32-bits.

You might want to seriously consider following the x32 folks and use 64
bits, as 2038 isn't very far away.

thanks
-john


