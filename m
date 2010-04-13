Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0DMXTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:19:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:58866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753460Ab0DMXTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:19:53 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+mbY8HIkimeU6HUeKjbGKOG9Lt7EF6mvwBPGcTbR
	GLcQQV9a7NvXHR
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: Parallel port LCD driver undocumented
Date: Wed, 14 Apr 2010 01:19:53 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Michal Suchanek <hramrach@centrum.cz>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
       willy@meta-x.org
References: <y2qa5d587fb1004131613obfc84dc2yd862cd79d7a3b084@mail.gmail.com>
In-Reply-To: <y2qa5d587fb1004131613obfc84dc2yd862cd79d7a3b084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004140119.53687.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 14 April 2010 01:13:40 schrieb Michal Suchanek:
> Hello
> 
> I was thinking about adding a LCD to my PC so I thought that the
> panel.c driver which just went to 2.6.34 would be helpful.
> 
> The problem is there is no documentation. I can get quite detailed
> documentation for at least some LCDs that are sold around here but
> there is not enough documentation for the driver to determine if the
> LCD in question would be compatible with the driver and with which
> protocol.
> 
> Detailed explanation of the parameters would be appreciated. For
> example, there are three parallel protocols supported but there is no
> description of the difference between them.
> 
> Thanks

Hi,
I CC'ed willy - the original author of the driver - maybe he can help out.


Meanwhile - did you have a look at LCDproc?
http://lcdproc.org/
Userspace "drivers" for a lot of lcds and keypads.

Peter




