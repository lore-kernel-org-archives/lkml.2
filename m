Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0KZUQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 15:16:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:37159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab0KZUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 15:16:09 -0500
Message-ID: <4CF01583.5050307@kernel.org>
Date: Fri, 26 Nov 2010 21:16:03 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Tobias Karnat <tobias.karnat@googlemail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sata_sil24: external raid storage mistaken as port multiplier
References: <1290461073.12443.21.camel@Tobias-Karnat>	 <1290514125.28293.2.camel@Tobias-Karnat> <1290572588.24847.20.camel@Tobias-Karnat> <4CEFEC17.6060503@kernel.org> <4CF014F8.9000700@teksavvy.com>
In-Reply-To: <4CF014F8.9000700@teksavvy.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 20:16:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/26/2010 09:13 PM, Mark Lord wrote:
>> That said, yeah, it probably would be a good idea to add a
>> libata.force param.
> 
> How about some form of auto-detection instead?

That's a device which reports that it's a PMP but fails to behave
itself as one.  The sucky thing is that depending on the current mode
and firmware revision, the same hardware can actually bahave as a
pretty decent PMP.  I frankly have no idea how to work it around.

-- 
tejun
