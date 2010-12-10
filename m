Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0LJXtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:49:32 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:4276 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0LJXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:49:30 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Subject: Re: [PATCH] driver-core: document restrictions on device_rename()
References: <1291246854-19283-1-git-send-email-timur@freescale.com> <20101210231254.GA9845@kroah.com>
Content-Transfer-Encoding: 7bit
From: Tabi Timur-B04825 <B04825@freescale.com>
Content-Type: text/plain; charset="us-ascii"
thread-topic: [PATCH] driver-core: document restrictions on device_rename()
thread-index: AcuYxRkLyRkANW4YSpy0r2B+ccZTzg==
In-Reply-To: <20101210231254.GA9845@kroah.com>
Message-ID: <E9E64D4D-F204-4EEE-B0F4-FE106B7BD8CA@freescale.com>
Date: Fri, 10 Dec 2010 16:47:49 -0700
To: Greg KH <greg@kroah.com>
CC: <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0 (iPad Mail 8C148)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm on vacation, so it'll have to wait until Monday.


On Dec 10, 2010, at 4:17 PM, "Greg KH" <greg@kroah.com> wrote:

> On Wed, Dec 01, 2010 at 05:40:54PM -0600, Timur Tabi wrote:
>> Add text, courtesy of Kay Sievers, that provides some background on
>> device_rename() and why it shouldn't be used.
>> 
>> Signed-off-by: Timur Tabi <timur@freescale.com>
>> ---
>> drivers/base/core.c |   28 ++++++++++++++++++++++++++++
> 
> This patch doesn't apply to the linux-next branch, care to refresh it so
> I can apply it?
> 
> thanks,
> 
> greg k-h
> 

