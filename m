Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0LHTWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:22:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0LHTWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:22:01 -0500
Message-ID: <4CFFDA7C.5050303@kernel.org>
Date: Wed, 08 Dec 2010 11:20:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
References: <1291232292.32004.1969.camel@laptop>	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>	 <1291764620.2032.1293.camel@laptop>  <20101208140103.GM21786@redhat.com>	 <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop>	 <4CFFD1C2.1080108@kernel.org> <1291835196.28378.145.camel@laptop>
In-Reply-To: <1291835196.28378.145.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 11:06 AM, Peter Zijlstra wrote:
>> then still can use perf etc after we kexec from RHEL or SLES kernel to
>> later kernel ( from 2.6.37)
> 
> I'm not sure why people would do that, but yeah I guess we can do
> something like that.

more problem:
system with linuxbios and have kernel in flash as bootloader. they may kexec to final production kernel. 

and they may need to update that embedded kernel to shutdown perf....

Yinghai
