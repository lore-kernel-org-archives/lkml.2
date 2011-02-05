Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1BEW4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 17:56:34 -0500
Received: from lucidpixels.com ([75.144.35.66]:37313 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1BEW4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 17:56:33 -0500
Date: Sat, 5 Feb 2011 17:56:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
In-Reply-To: <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Feb 2011, Justin Piszcz wrote:

>
>
> On Sat, 5 Feb 2011, Dr. David Alan Gilbert wrote:
>
>> * Justin Piszcz (jpiszcz@lucidpixels.com) wrote:

Not sure how to copy/paste from an IPMI window, but I made my own
kernel for 2.6.37 in CentOS 5.5 (a pain) and now it is doing ~482-500MiB/s
sustained with a single copy (netcat from A->B).  Poor performance with the
default 2.6.18 kernel.  Seems to also slow down over time, down to 
434MiB/s now, but it started very quick and it remains between 
420-500MiB/s sustained.  Now 435-445MiB/s..

Justin.

