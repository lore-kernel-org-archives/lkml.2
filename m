Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1KDPgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:36:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52847 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1KDPgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:36:08 -0400
Message-ID: <4EB403C0.3040803@austin.ibm.com>
Date: Fri, 04 Nov 2011 10:24:48 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: hagar <hagar@iinet.net.au>
CC: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Nathan Lynch <nathanl@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Fwd: Kernel Power management ?? turning off used devices that
 are in use.
References: <4EA67567.3020704@iinet.net.au> <4EB38A44.5030606@iinet.net.au>
In-Reply-To: <4EB38A44.5030606@iinet.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11110415-5806-0000-0000-0000022E46B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I need to be able to either switch off cpu hotpluging - or at least 
> prevent hotplugging certain cpu's
>
> there should really be a mincpu's option or better a 
> nohotplug="0,1,2,5,7,etc" option.
>
> It would appear that cpu1 is the default cpu for those interrupts - 
> and they are not being transferred to cpu0 properly.
>
The proper way to fix this is to find why the interrupts are not being 
transferred and fix that.  Forcing cpus to not be hotpluggable is just 
hiding the problem.

> I have tried the kernel parameters noapic nosmp maxcpus acpi=off 
> possible_cpus=2 etc - with no success
>
> I did find a flaw in "possible_cpus=0" - this prevents the kernel 
> booting (no cpus available )
> This option should be set to a minimum of 1
>
We allow users to shoot themselves in the foot if they do silly things.  
This is a design decision.

