Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2KZPZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:25:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39614 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2KZPZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:25:34 -0500
Message-ID: <1353943531.10271.4.camel@hornet>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 26 Nov 2012 15:25:31 +0000
In-Reply-To: <1353325492.3303.0.camel@hornet>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
	 <1352388952.20549.12.camel@hornet> <1353325492.3303.0.camel@hornet>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Nov 2012 15:25:31.0252 (UTC) FILETIME=[45819B40:01CDCBEA]
X-MC-Unique: 112112615253213001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 11:44 +0000, Pawel Moll wrote:
> On Thu, 2012-11-08 at 15:35 +0000, Pawel Moll wrote:
> > Hi Bryan, Richard,
> > 
> > On Thu, 2012-11-01 at 17:58 +0000, Pawel Moll wrote:
> > > LEDs are often controlled by writing to memory mapped
> > > register. This patch adds:
> > > 
> > > 1. Generic functions for platform code and drivers to create
> > >    class device for LEDs controlled by arbitrary bit masks.
> > >    The control register value is read, modified by logic AND
> > >    and OR operations with respective mask and written back.
> > > 
> > > 2. A platform driver for simple use case when one or more LED
> > >    are controlled by consecutive bits in a register pointed
> > >    at by the platform device's memory resource. It can be
> > >    particularly useful for MFD cells being part of an other
> > >    device.
> > > 
> > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > 
> > It's just a friendly and polite nag - any thoughts or feelings about
> > this?
> 
> Ping again?

And another polite nag for this week...

Paweł


