Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1JYH6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:58:42 -0400
Received: from lucidpixels.com ([72.73.18.11]:49636 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1JYH6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:58:41 -0400
Date: Tue, 25 Oct 2011 03:58:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.1-rcX (8,9,10): kernel does not validate swapfile on disk(?)
 - WAS: vnc4server 4.1.1+X4.3.0-3 crashing under normal use
In-Reply-To: <alpine.DEB.2.02.1110231756250.20069@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1110250357350.9631@p34.internal.lan>
References: <alpine.DEB.2.02.1110221939380.26496@p34.internal.lan> <alpine.DEB.2.02.1110231756250.20069@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Back to the drawing board, while it did seem to help, it crashed a day or 
so later..

Mem:  49555968k total, 43546968k used,  6009000k free, 13823244k buffers
Swap: 31248972k total,   125432k used, 31123540k free, 26341364k cached

[158525.666164] Xvnc4[19596]: segfault at 8 ip 00000000004cbed4 sp
00007fffe95b0ec0 error 4 in Xvnc4[400000+450000]

Justin.

