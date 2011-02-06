Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1BFKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:16:59 -0500
Received: from lucidpixels.com ([75.144.35.66]:42666 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab1BFKQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:16:57 -0500
Date: Sun, 6 Feb 2011 05:16:57 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
        Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
In-Reply-To: <4D4E127D.3060105@hardwarefreak.com>
Message-ID: <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
 <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com> <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan> <4D4E127D.3060105@hardwarefreak.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Feb 2011, Stan Hoeppner wrote:

> Justin Piszcz put forth on 2/5/2011 7:08 PM:
>
>> Overall performance is good, but now I need to figure out how to tweak the
>> network and/or disk paths so I can achieve > 1Gbyte/sec, as the RAID-0s can
>> read and write > 1.2Gbyte/sec.
>>
>> Has anyone with 10GbE <-> 10GbE been able to transfer at or near line rate
>> with a single connection, or > 700MiB/s with multiple connections?  Problem
>> I worry about with creating multiple connections between two machines it will
>> create contention within the RAID that is being read from..
>
> Are you trying to maximize this for the sake of maximizing it, or do you have an
> actual application or work flow process that needs to be able to transfer a
> single large file via NFS at >1 GB/s throughput?

Workflow process-

Migrate data from old/legacy RAID sets to new ones, possibly also 
2TB->3TB, so the faster the transfer speed, the better.

Justin.

