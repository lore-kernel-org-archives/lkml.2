Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2LRTuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:50:35 -0500
Received: from plane.gmane.org ([80.91.229.3]:50245 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2LRTue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:50:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: rh <richard_hubbe11@lavabit.com>
Subject: Re: FYI, nouveau nv17 stopped working in 3.7
Date: Tue, 18 Dec 2012 11:50:19 -0800
Message-ID: <20121218115019.c75bb9d1dea07bbf93319b22@lavabit.com>
References: <20121213140229.d47b2a1584ef1c59ed76bc0c@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip70-185-179-140.sb.sd.cox.net
User-Agent: dsodnetnin
X-Mailer: EZnn0.37p
X-Newsreader: EZnn0.37p
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: expiry=11
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 14:02:29 -0800
rh <richard_hubbe11@lavabit.com> wrote:

> During boot, at the point when some graphics stuff happens, I lose the
> screen. Graphics looks to be stuck somewhere. The system boots but
> just can't see anything.  No console.
> 
> It's all fine in 3.6.7. Nothing jumped out from the boot log.
> It may be that in my haste configuring the kernel with make oldconfig
> I hit enter on one of the cases where new features default to "y".
> 

Seems to be a regression, the symptoms described here apply to what
I see (...or don't see).

http://article.gmane.org/gmane.linux.kernel/1269631

