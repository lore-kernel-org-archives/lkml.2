Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1AUMty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:49:54 -0500
Received: from lo.gmane.org ([80.91.229.12]:49850 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab1AUMtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:49:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: how to avoid that install.sh goes mad, if I am not root?
Date: Fri, 21 Jan 2011 12:49:37 +0000 (UTC)
Message-ID: <ihbvd1$jbj$3@dough.gmane.org>
References: <4D388A08.1010004@afaics.de>
	<19768.44428.482148.361069@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 123.125.1.164
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 22:47:56 +0100, Mikael Pettersson wrote:
> 
> First, at least on x86, the kernel will look for the 'installkernel'
> executable first in your own ~/bin/, so if you have that then it will
> override /sbin/installkernel.
> 

That still doesn't look like a good solution.

/me is thinking if we should have a new Kconfig for this, e.g.
CONFIG_INSTALL_KERNEL whose default value is "/sbin/installkernel".

Cheers.

