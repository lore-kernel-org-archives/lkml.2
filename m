Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1HXG2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:28:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41281 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1HXG2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E53D8D4.5080208@broadcom.com>
References: <20110823112128.GA2825@maxin>
	<4E53D8D4.5080208@broadcom.com>
Date: Wed, 24 Aug 2011 09:28:00 +0300
Message-ID: <CAMhs6Yx6DDA4guyiUEQ6K74iouQcqA5rpvo6iY+Qd_Vdi0GhGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: mach-bcmring: fix build error in dma.c
From: Maxin B John <maxin.john@gmail.com>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 7:44 PM, Jiandong Zheng <jdzheng@broadcom.com> wrote:
> On 8/23/2011 4:21 AM, Maxin B John wrote:
>>
>>  CC      arch/arm/mach-bcmring/dma.o
>>
> Signed-off-by: Jiandong Zheng <jdzheng@broadcom.com>
>
> I have same fix submitted on May 12, which was supposed to be applied soon
> but seems it wasn't.

Oh.. I wasn't aware of that. Please feel free to ignore this one and
go ahead with your patch.

Regards,
Maxin
