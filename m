Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1J3AfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 20:35:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:34254 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab1J3AfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 20:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Trulan Martin <trulanm@gmail.com>
Subject: Re: PROBLEM: Intermittent hard locks on 3.0.7-1 without information
Date: Sun, 30 Oct 2011 00:33:04 +0000 (UTC)
Message-ID: <loom.20111030T022518-383@post.gmane.org>
References: <4EAC40B5.5060709@earnshaw.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 71.200.26.42 (Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1 Iceweasel/7.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Earnshaw <matt <at> earnshaw.org.uk> writes:

> 
> [1.] 3.0.7-1 appears to cause hard locks intermittently, without information
> 
It sounds like the problem addressed by this patch:
https://lkml.org/lkml/2011/10/18/100
Try either that patch or 3.0.8.

-Trulan


