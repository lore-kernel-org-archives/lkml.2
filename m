Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0JaABg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 20:01:36 -0400
Received: from nitrogen.vapor.com ([213.203.212.226]:49868 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0JaABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 20:01:34 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Oct 2010 20:01:33 EDT
Date: Sun, 31 Oct 2010 01:52:08 +0200 (CEST)
From: Ian Kumlien <pomac@demius.net>
X-X-Sender: pomac@twilight.pomac.com
To: linux-kernel@vger.kernel.org
Subject: High [extra timer interrupt] count in powertop since 2.6.36
Message-ID: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been searching the list for anyone else seeing this,
but i haven't found anything yet - Any ideas on how to debug?

>From powertop:
Top causes for wakeups:
   84.7% (1673.3)   [extra timer interrupt]

Thats a little bit high in my opinion, for some reason it seems to be
ignored since the actual number of wakeups seems to be ~367 or so.

Ideas? Suggestions?
