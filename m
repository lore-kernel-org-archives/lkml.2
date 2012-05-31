Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2EaOF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035Ab2EaOFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:05:55 -0400
Message-ID: <4FC7788C.1070405@redhat.com>
Date: Thu, 31 May 2012 10:56:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FBE5E1D.7070804@redhat.com> <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com> <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com> <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com> <20120531100005.GC14074@aftab.osrc.amd.com> <4FC748F5.9070709@redhat.com> <20120531121741.GB14515@aftab.osrc.amd.com>
In-Reply-To: <20120531121741.GB14515@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-05-2012 09:17, Borislav Petkov escreveu:
> On Thu, May 31, 2012 at 07:33:25AM -0300, Mauro Carvalho Chehab wrote:
>> Huh? Tony said that some errors report at 4K granularity while, others
>> are at cache line size.
> 
> Cacheline size is from MCE. This tracepoint is for memory controller
> errors where granularity should be pretty stable.

Both sb_edac and i7core_edac get errors via MCE. They're currently providing
a fake granularity, but I'm planning to add proper grain support on them,
by retrieving such information from the MCE registers.

Regards,
Mauro


