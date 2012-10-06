Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2JFOxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 10:53:39 -0400
Received: from plane.gmane.org ([80.91.229.3]:44919 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab2JFOxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 10:53:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el_es <el.es.cr@gmail.com>
Subject: Re: Minimal jitter = good desktop.
Date: Sat, 6 Oct 2012 14:53:16 +0000 (UTC)
Message-ID: <loom.20121006T164640-362@post.gmane.org>
References: <op.wlqe9kw36426ze@localhost.localdomain> <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm> <op.wlrdzkqh6426ze@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.31.113.250 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwaysi Bin Kareem <uwaysi.bin.kareem <at> paradoxuncreated.com> writes:

[sorry for cutting out the context], but it's been topposted]

But the problem is, we cannot measure 'jitter' directly.
There is no reliable benchmark that produces results adherent
to what someones' definition of 'jitter' is.

At software level we only have a notion of latency, and that
leads to jitter as david said, but as the kernel is not real-time,
you cannot guarantee every opengl command/fb transfer will be finished
in time for next frame to be drawn.

Maybe if someone could get the information of % finished frames
(or % dropped frames) within one slice of userspace, that would 
be something to build on, but it's still a derivative and with 
unknown bias level.

Lukasz

