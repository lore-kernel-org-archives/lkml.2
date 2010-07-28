Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0G1TMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:12:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56118 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750939Ab0G1TMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:12:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19sDVlUqwBsxQpMcs8Z0NgBGYitxDNpQ2yhmBu/yZ
	67cjoO2rTbDYcU
Date: Wed, 28 Jul 2010 21:12:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: rd bairva <rbairva@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: JPEG hw decoder
In-Reply-To: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1007282110130.23907@axis700.grange>
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010, rd bairva wrote:

> Hi ,
>       My board has a hardware JPEG decoder. I want to write a driver
> for this in Linux kernel, But it seems there that no Framework exists
> in kernel. Can somebody provide me some pointers?

drivers/media/video, maybe v4l2-mem2mem kind of thing.

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
