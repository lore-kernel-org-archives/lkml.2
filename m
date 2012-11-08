Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab2KHPf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:35:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44176 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2KHPfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:35:54 -0500
Message-ID: <1352388952.20549.12.camel@hornet>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 08 Nov 2012 15:35:52 +0000
In-Reply-To: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Nov 2012 15:35:52.0247 (UTC) FILETIME=[BC366C70:01CDBDC6]
X-MC-Unique: 112110815355208801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Richard,

On Thu, 2012-11-01 at 17:58 +0000, Pawel Moll wrote:
> LEDs are often controlled by writing to memory mapped
> register. This patch adds:
> 
> 1. Generic functions for platform code and drivers to create
>    class device for LEDs controlled by arbitrary bit masks.
>    The control register value is read, modified by logic AND
>    and OR operations with respective mask and written back.
> 
> 2. A platform driver for simple use case when one or more LED
>    are controlled by consecutive bits in a register pointed
>    at by the platform device's memory resource. It can be
>    particularly useful for MFD cells being part of an other
>    device.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

It's just a friendly and polite nag - any thoughts or feelings about
this?

Cheers!

Paweł


