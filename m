Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0LHTFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:05:31 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:57015 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203Ab0LHTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:05:29 -0500
Message-ID: <4CFFD6D2.5060703@euromail.se>
Date: Wed, 08 Dec 2010 20:04:50 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <20101207091653.GA22416@core.coreip.homeip.net> <4CFE919A.1040704@euromail.se> <20101208060200.GD4140@core.coreip.homeip.net>
In-Reply-To: <20101208060200.GD4140@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQPJu-00083s-3N.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQPJu-00083s-3N c5784e828d3809906bb2bc7449f4c2ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One concern is that while 32 distinct device types should be enough

> should we plan for larger capability array? Should we use variable
> length ioctl - like EVIOCGKEY(len) - even though Arnd does not like
> them?


Sounds good, but then again the struct approach feels quite extensible too...


> Also, we already have /sys/class/input/input0/capabilities/ so should we
> call new data item something else? Quirks maybe?


Works fine in my book.

Thanks,
Henrik
