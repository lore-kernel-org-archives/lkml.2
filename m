Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2F1JZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:25:06 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:48427 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab2F1JZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:25:05 -0400
Message-ID: <4FEC22E8.5030707@med.uni-frankfurt.de>
Date: Thu, 28 Jun 2012 11:24:56 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
References: <4FDF00CB.7090703@med.uni-frankfurt.de> <4FDF201E.2090408@med.uni-frankfurt.de> <4FE19494.6000303@med.uni-frankfurt.de> <4FE86067.9010408@med.uni-frankfurt.de> <4FEAF165.9090008@med.uni-frankfurt.de> <20120627174649.GA28137@x1.osrc.amd.com> <4FEBF277.90704@med.uni-frankfurt.de> <20120628064213.GC450@x1.osrc.amd.com>
In-Reply-To: <20120628064213.GC450@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any chance you could try a non-rt kernel,

Earlier in this thread I wrote, that 3.4.[23] are
in fact unaffected. Only 3.4.[234]-rt1[0123] show
this BUG in dmesg.

> to rule out an -rt issue?

Steven Rostedt wrote (w/o CC:LKML) that he believes
CPU hotplug is still an issue with -rt. So, are you
still interested to follow the "amd on intel" thing?

> Also, looks like your cpu can do 64-bit. Can you
> try a 64-bit kernel?

Yes, it's a 32-bit userland on 64-bit hardware. So
far I didn't compile 64-bit kernels on 32-bit user-
land but in case you're still interested in the
result, I'll give it a try.

> Also, what is the exact command line you're running
> with chcpu?

# chcpu --disable 1

Thomas
