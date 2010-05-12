Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0ELR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:56:12 -0400
Received: from server109f.appriver.com ([72.32.253.90]:2209 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754299Ab0ELR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:56:11 -0400
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G193 G194 G195 G196 G200 G201 G212 G300 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4BEAEC2A.6090306@intcomgrp.com>
Date: Wed, 12 May 2010 13:58:02 -0400
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dhaval Giani <dhaval.giani@gmail.com>
CC: Jan Safranek <jsafrane@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, lennart@poettering.net, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>	 <1273674048.1626.117.camel@laptop> <4BEABDF8.40206@redhat.com>	 <4BEAE7A1.2010001@intcomgrp.com> <AANLkTikEyJ8q9GkpyZo0OUY4MLM_soWEviiBG2R6H-mY@mail.gmail.com>
In-Reply-To: <AANLkTikEyJ8q9GkpyZo0OUY4MLM_soWEviiBG2R6H-mY@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2010 17:58:02.0029 (UTC) FILETIME=[AA099DD0:01CAF1FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/2010 1:42 PM, Dhaval Giani wrote:
>
> I seem to get the impression that there is a miscommunication here. We
> are talking about the cgroups feature here (more details are available
> at http://www.mjmwired.net/kernel/Documentation/cgroups.txt ). We
> really are not talking about devices, but about specific cgroup
> subsystems which can be mounted together, and are not under the
> control of the programmer.
>
>   
>
> Dhaval
>
>   
Thanks for clearing that up.
It looks like they are not under the control of the programmer on
purpose.  It is not outlined in the description of how to use this feature.
The tasks have to be added separately by an administrator that is
operating the system to tune performance and to provide resources where
most needed.


