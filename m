Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab2BJUSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:18:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:36976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2BJUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:18:50 -0500
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
In-Reply-To: <20120210200250.GG5650@redhat.com>
References: <1328751082.5611.6.camel@lappy>
	 <CA+5PVA6HNqYv7kw3Oq_+05LwrXwtnNnZDkntcrncT2OmGXDd=w@mail.gmail.com>
	 <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
	 <4F34EC35.7010109@linux.vnet.ibm.com> <1328900283.25989.45.camel@laptop>
	 <1328900633.25989.47.camel@laptop>  <20120210200250.GG5650@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 21:18:41 +0100
Message-ID: <1328905121.25989.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 15:02 -0500, Don Zickus wrote:
> I also ran into the same problem you did and hacked up another patch that
> checked a global atomic variable that let the system know we were shutting
> down and not to do the WARN_ON (the global is already created for the NMI
> case now). 

system_state seems like that thing.. 

