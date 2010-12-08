Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0LHTHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:07:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19054 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab0LHTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:07:39 -0500
Message-ID: <4CFFD715.4090900@kernel.org>
Date: Wed, 08 Dec 2010 11:05:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
References: <1291234036.32004.2008.camel@laptop> <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com> <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com> <1291764620.2032.1293.camel@laptop> <20101208140103.GM21786@redhat.com> <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop> <4CFFD1C2.1080108@kernel.org> <20101208190158.GA8565@redhat.com>
In-Reply-To: <20101208190158.GA8565@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 11:01 AM, Don Zickus wrote:
> On Wed, Dec 08, 2010 at 10:43:14AM -0800, Yinghai Lu wrote:
>>
>> can you add sth force_... in command line to take over ownership of perf from BIOS or previous kernel ?
>>
>> then still can use perf etc after we kexec from RHEL or SLES kernel to later kernel ( from 2.6.37)
> 
> My understand is that you can't because the BIOS is actively using it
> behind the scenes of the kernel (well during an SMI).  I have a machine
> where I tried to force take it but it still stopped triggering interrupts.

how about second case: kexec from RHEL 6 stock kernel to upstream kernel ?

Thanks

	Yinghai
