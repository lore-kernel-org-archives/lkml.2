Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1LURNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:13:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18874 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1LURNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:13:46 -0500
Message-ID: <4EF213BD.4070107@oracle.com>
Date: Wed, 21 Dec 2011 11:13:33 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Nico Schottelius <nico-linux-20111201@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] deadlock: jfs (3.2.0-rc4-00154-g8e8da02)
References: <20111206100533.GB6161@schottelius.org>
In-Reply-To: <20111206100533.GB6161@schottelius.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4EF213C0.015B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 04:05 AM, Nico Schottelius wrote:
> Hello,
> 
> my kernel screams for getting unlocked:
> 
> [ 6281.127360] ---------------------------------
> [ 6281.127363] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
> usage.
> [ 6281.127366] kswapd0/30 [HC0[0]:SC0[0]:HE1:SE1] takes:
> 
> This happened after a suspend/resume cycle on the macbookair.

Thanks Nico. I should have added you to the cc. The deadlock is being
addressed in this thread: https://lkml.org/lkml/2011/12/20/387

Shaggy

> 
> dmesg attached.
> 
> Cheers,
> 
> Nico
> 
