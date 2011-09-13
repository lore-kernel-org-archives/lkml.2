Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1IMO6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:58:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38331 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1IMO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
Date: Tue, 13 Sep 2011 16:58:12 +0200
Message-ID: <CAL4WiipmRyprf3nU-mgz8zE+n=Cy_Th=MT1JMnO=Qy_993++yw@mail.gmail.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        Alan Piszcz <ap@solarrain.com>, NetDEV list <netdev@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/13 Justin Piszcz <jpiszcz@lucidpixels.com>:
>

> I found this commit here:
> http://permalink.gmane.org/gmane.linux.kernel.pci/11700
>
> Applied:
> # patch -p1 < ../ed2888e906b56769b4ffabb9c577190438aa68b8.txt patching file
> drivers/pci/probe.c
>
>

Oh, I should have sent the git anchor you can use instead of searching the web ;

git pull https://github.com/torvalds/linux.git
