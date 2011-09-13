Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1IMDSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1IMDSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:18:06 -0400
Subject: Re: [PATCH 10/24] C6X: time management
From: Mark Salter <msalter@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 Sep 2011 23:18:04 -0400
In-Reply-To: <CANcMJZBxCQFgAsO89X+_SSm02vtseRhY7ozoxik4UMEuJUdDNQ@mail.gmail.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-11-git-send-email-msalter@redhat.com>
	 <CANcMJZBxCQFgAsO89X+_SSm02vtseRhY7ozoxik4UMEuJUdDNQ@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315883885.11280.34.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 18:16 -0700, john stultz wrote:
> On Wed, Aug 31, 2011 at 2:26 PM, Mark Salter <msalter@redhat.com> wrote:
> > The C6X architecture includes a 64-bit free running core clock counter which
> > is used as the clocksource. The SoCs have a number of 64-bit programmable
> > timers. One of these is used as the clockevent timer.
> >
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> 
> Sort of a tangent to this specific patch, but since it came up
> recently in the x32 discussion, I wanted to check if you were using a
> 64bit definition of time_t?

C6X uses the asm-generic definition which is a long, so 32-bits.

--Mark


