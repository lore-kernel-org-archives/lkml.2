Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2HQVze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:55:34 -0400
Received: from seven.medozas.de ([5.9.24.206]:56018 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2HQVzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:55:24 -0400
Date: Fri, 17 Aug 2012 23:55:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Phil Turmel <philip@turmel.org>
cc: Kevin Ross <kevin@familyross.net>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: RAID extremely slow
In-Reply-To: <501096C3.5060700@turmel.org>
Message-ID: <alpine.LNX.2.01.1208172353260.3927@frira.zrqbmnf.qr>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-07-26 03:00, Phil Turmel wrote:
>> I used atop to show the transfer speeds to each drive. Here's a
>> screenshot:
>> http://img402.imageshack.us/img402/6484/screenshotfrom201207251.png
>
>[ The output of "lsdrv" [1] might be useful here, along with
>"mdadm -D /dev/md0" and "mdadm -E /dev/[b-j]" ]
>[1] http://github.com/pturmel/lsdrv

lsdrv? Shows a bunch, but for this, using standard tools
like lsscsi & lsblk seems sufficient :)
