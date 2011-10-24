Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1JXG6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 02:58:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51543 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1JXG6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 02:58:24 -0400
Date: Mon, 24 Oct 2011 02:58:22 -0400 (EDT)
Message-Id: <20111024.025822.548298031734112062.davem@davemloft.net>
To: grawity@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] jme: fix irq storm after suspend/resume
From: David Miller <davem@davemloft.net>
In-Reply-To: <j7uqst$kpc$1@dough.gmane.org>
References: <20111022125620.GA2256@ecki.lan>
	<j7uqst$kpc$1@dough.gmane.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 23 Oct 2011 23:58:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mantas M." <grawity@gmail.com>
Date: Sat, 22 Oct 2011 19:27:09 +0300

> On 22/10/11 15:56, Clemens Buchacher wrote:
>> If the device is down during suspend/resume, interrupts are enabled
>> without a registered interrupt handler, causing a storm of
>> unhandled interrupts until the IRQ is disabled because "nobody
>> cared".
>>
>> Instead, check that the device is up before touching it in the
>> suspend/resume code.
>>
>> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=39112
> 
> Just tested the patch, suspend/resume works well.

Applied, thanks.
