Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2KSLo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:44:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34205 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KSLoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:44:55 -0500
Message-ID: <1353325492.3303.0.camel@hornet>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 19 Nov 2012 11:44:52 +0000
In-Reply-To: <1352388952.20549.12.camel@hornet>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
	 <1352388952.20549.12.camel@hornet>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Nov 2012 11:44:53.0359 (UTC) FILETIME=[4A372FF0:01CDC64B]
X-MC-Unique: 112111911445404701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 15:35 +0000, Pawel Moll wrote:
> Hi Bryan, Richard,
> 
> On Thu, 2012-11-01 at 17:58 +0000, Pawel Moll wrote:
> > LEDs are often controlled by writing to memory mapped
> > register. This patch adds:
> > 
> > 1. Generic functions for platform code and drivers to create
> >    class device for LEDs controlled by arbitrary bit masks.
> >    The control register value is read, modified by logic AND
> >    and OR operations with respective mask and written back.
> > 
> > 2. A platform driver for simple use case when one or more LED
> >    are controlled by consecutive bits in a register pointed
> >    at by the platform device's memory resource. It can be
> >    particularly useful for MFD cells being part of an other
> >    device.
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> 
> It's just a friendly and polite nag - any thoughts or feelings about
> this?

Ping again?

Paweł


