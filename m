Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1CGVmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:42:37 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:61130 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab1CGVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:42:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIGALvfdE2rRN+K/2dsb2JhbACmVQJ0okScAoViBIUchxSDSYUv
X-IronPort-AV: E=Sophos;i="4.62,279,1297036800"; 
   d="scan'208";a="341895501"
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Mon, 07 Mar 2011 13:42:37 -0800
Subject: Re: [PATCH] hwmon: (pmbus) Improve support for paged fans
From: Greg Schnorr <gschnorr@cisco.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <C99A914D.5A89C%gschnorr@cisco.com>
Thread-Topic: [PATCH] hwmon: (pmbus) Improve support for paged fans
Thread-Index: AcvdEJNC0oSeL1p9lkWsMb3ycOVWyw==
In-Reply-To: <1299341303-32570-1-git-send-email-guenter.roeck@ericsson.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2011 21:42:31.0846 (UTC) FILETIME=[902FD460:01CBDD10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verified this patch works as expected on such "fan rich" hardware...

On 3/5/11 8:08 AM, "Guenter Roeck" <guenter.roeck@ericsson.com> wrote:

> So far, it seemed like fans would either all be in page 0, or that
> there would be one page per fan.
> 
> Turns out this was a wrong assumption. There is at least one PMBus
> fan controller which supports three pages with four fans each.
> Update code to handle this situation.
> 
> Reported-by: Greg Schnorr <gschnorr@cisco.com>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Greg Schnorr <gschnorr@cisco.com>

