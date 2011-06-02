Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1FBQvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:51:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:45244 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1FBQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:51:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Olaf Freyer <aaron667@gmx.net>
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
Date: Thu, 2 Jun 2011 16:50:59 +0000 (UTC)
Message-ID: <loom.20110602T182348-862@post.gmane.org>
References: <4DD9092A.4080507@gmx.net> <loom.20110525T172412-101@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 92.231.243.7 (Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20110525 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I'm not yet 100% sure, but I think the package power limit notification events,
> I see in /var/log/messages might coincide with the moment of my xorg startup.

I tested it for a few evenings and I can now confirm my previous assumption.
Running the system on console for hours doesn't trigger any such event - 
as soon as I start up X it happens at once. 

Is there any extra info I can provide to get this issue solved?

Regards
  Olaf Freyer

