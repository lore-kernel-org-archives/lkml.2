Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab1JXSP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:15:29 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:39823 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932872Ab1JXSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:15:28 -0400
Message-ID: <4EA5AB40.2090609@profihost.ag>
Date: Mon, 24 Oct 2011 20:15:28 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, Stable Tree <stable@kernel.org>
Subject: Re: Kernel hard LOCKUP with v3.0.7
References: <4EA1536E.6090001@profihost.ag> <20111021130752.GC8219@suse.de> <AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag> <20111021200257.GA31198@suse.de> <4EA2F2E0.4020702@profihost.ag> <20111022165521.GA1716@suse.de>
In-Reply-To: <20111022165521.GA1716@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.10.2011 18:55, schrieb Greg KH:
>> this seems to fix it. Perhaps you should release v3.0.8 as the
>> stable tree isn't stable right now? I mean this bug seems to be
>> triggered on every SMP machine.
> I will work to get it out soon.
Fine. Any idea if this will happen this week or in a month or ... I'm 
scheduling an update for all our systems and if this will happen really 
soon i will probably schedule it a bit later.

> thanks for testing and letting me know.
np

Stefan
