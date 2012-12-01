Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2LAN3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:29:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2LAN3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:29:07 -0500
Date: Sat, 1 Dec 2012 11:28:25 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        rostedt@goodmis.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] aerdrv: Trace Event for AER
In-Reply-To: <20121201114310.GA7853@liondog.tnic>
Message-ID: <alpine.LFD.2.02.1212011127560.3172@localhost.localdomain>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net> <20121201093614.720aa96a@redhat.com> <20121201114310.GA7853@liondog.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Cheers,
Mauro

On Sat, 1 Dec 2012, Borislav Petkov wrote:

> On Sat, Dec 01, 2012 at 09:36:14AM -0200, Mauro Carvalho Chehab wrote:
>> Please don't call it as "ras.h". Call it, instead, ras_aer.h
>> (or something similar) as, if we're moving the tracing back to
>> include/trace/events/, the same should happen for the memory error
>> events.
>
> As you can see yourself, include/trace/events/ contains one header per
> topic so having ras_event.h and ras_aer.h or whatever, doesn't fit the
> scheme. IOW, we want all RAS-specific tracepoints to be collected in a
> header called ras.h like the rest of the subsystems do it. See rcu.h
> there for a good example.

Works for me.

Regards,
Mauro
