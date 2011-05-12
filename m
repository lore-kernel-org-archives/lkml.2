Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab1ELWH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab1ELWH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:07:27 -0400
Date: Thu, 12 May 2011 18:07:16 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512220715.GA7451@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
 <20110512213542.GB17596@elte.hu>
 <BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
 <20110512215023.GA20939@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512215023.GA20939@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:50:23PM +0200, Ingo Molnar wrote:
 
 > Dunno, i would not couple them necessarily - certain users might still have 
 > access to kernel symbols via some other channel - for example the System.map.
 
That always made this security by obscurity feature seem pointless for the bulk
of users to me. Given the majority are going to be running distro kernels,
anyone can find those addresses easily no matter how hard we hide them on the
running system.

Unless we were somehow introduced randomness into where we unpack the kernel
each boot, and using System.map as a table of offsets instead of absolute addresses.

	Dave

