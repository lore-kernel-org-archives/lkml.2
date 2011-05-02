Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1EBIAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:00:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1EBIAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:00:15 -0400
Date: Mon, 2 May 2011 09:59:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Simon Horman <horms@verge.net.au>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 0/2] locking power management for shdma dmaengine driver
In-Reply-To: <20110502072044.GC3980@verge.net.au>
Message-ID: <Pine.LNX.4.64.1105020959040.13244@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
 <20110502072044.GC3980@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:X0RyGZxA9pKTudf7d4eGQFIkhba2pGd94AbnW0QI2uu
 Qh5EnzdOPjiFsDH9AtG6TpxXTjZa99kN+OJtzwvbkc6lIoJOAT
 QbEqX/V8bnk6xP5w77mNUOWsSKupWIwcIFwZj2c4X71mKzj1z7
 RPCWcfNaAG3UKq524O3FpP7e7Wza+wexz0i7mtoc6TiW9tzjW2
 +PeDGVZPOn+NdsTHQCGyx6N/MZRII2N5gTcH6yIVJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Simon Horman wrote:

> On Fri, Apr 29, 2011 at 07:09:17PM +0200, Guennadi Liakhovetski wrote:
> > Two improvements and enhancements for the shdma driver.
> 
> Hi Geunnadi,
> 
> which tree are these based on?
> I am not having any luck applying them
> on top of 2.6.39-rc5.

Sorry, you also need another patch before these two, that I have just sent 
to the list cc: you.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
