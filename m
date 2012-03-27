Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2C0TOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:14:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2C0TOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:14:21 -0400
Message-ID: <1332875639.16159.255.camel@twins>
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net
Date: Tue, 27 Mar 2012 21:13:59 +0200
In-Reply-To: <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	 <20120323190855.GA27213@www.outflux.net>
	 <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 14:05 -0400, Josh Boyer wrote:
> 
> Do you really need WARN_ONCE?  It's going to spew a backtrace if this
> is called, and that is going to cause various auto-bug reporters to file
> bugs as well.  

That's a positive, right? That gives extra visibility to who and what
might possibly use this thing.
