Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1BEXy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:54:57 -0500
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:46926 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1BEXy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:54:56 -0500
Message-ID: <4D4DE34E.7010308@hardwarefreak.com>
Date: Sat, 05 Feb 2011 17:54:54 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "Dr. David Alan Gilbert" <linux@treblig.org>,
        Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan> <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz put forth on 2/5/2011 4:56 PM:

> Not sure how to copy/paste from an IPMI window, but I made my own
> kernel for 2.6.37 in CentOS 5.5 (a pain) and now it is doing ~482-500MiB/s
> sustained with a single copy (netcat from A->B).  Poor performance with the
> default 2.6.18 kernel.  Seems to also slow down over time, down to 434MiB/s now,
> but it started very quick and it remains between 420-500MiB/s sustained.  Now
> 435-445MiB/s..

I forgot you mentioned CentOS.  Their kernel and apps are always very old.
2.6.18 was release in Sept 2006 IIRC--4+ years ago.  It was the "pirate themed"
release.

With 2.6.37 what do you get with 4 concurrent nfs copy ops?  If the aggregate
nfs throughput doesn't increase, you need to tweak your nfs server (and possibly
client).  With that hardware and a recent kernel you should be able to fill that
10 GbE pipe, or come really close.

-- 
Stan
