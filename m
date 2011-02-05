Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1BEWG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 17:06:27 -0500
Received: from mx.treblig.org ([80.68.94.177]:41850 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab1BEWGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 17:06:25 -0500
Date: Sat, 5 Feb 2011 22:06:21 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Message-ID: <20110205220621.GB17347@gallifrey>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.20-kvm-i386-20100823 (i686)
X-Uptime: 22:03:33 up 164 days,  6:30,  1 user,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Justin Piszcz (jpiszcz@lucidpixels.com) wrote:
>
>
> On Sat, 5 Feb 2011, Emmanuel Florac wrote:
>
>> Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous écriviez:
>>
>
> To respond to everyone:
>
>> Did you try launching 4 simultaneous cp operations over nfs to get to  
>> 1.2 GB/s?
>>  I've witnessed single stream copy performance with Samba being less than
>> maximum due to Samba limitations.  Running multiple copy ops in parallel then
>> usually saturates the pipe.
>
>
> I tried 4 simultaenous cp's and there was little change, 250-320MiB/s.

So I think you've said network benchmarks are OK, disc benchmarks are OK, but 
a copy over the network is slow.

What happens if you run a disc benchmark at the same time as a network benchmark;
even though the two aren't related? Can you keep the disc busy writing even when
the network is being pushed?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
