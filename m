Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab0HEVtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:49:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49723 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0HEVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:49:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C5B31C7.4000109@s5r6.in-berlin.de>
Date: Thu, 05 Aug 2010 23:48:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/42] drivers/ieee1394: Adjust confusing if indentation
References: <Pine.LNX.4.64.1008052219530.31692@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008052219530.31692@ask.diku.dk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> Indent the branch of an if.

Committed to linux1394-2.6.git.

> The semantic match that finds this problem is as follows:

It did not find this line though:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/feature-removal-schedule.txt;h=be7030e4dd73697ed5b979f02b6841dac7bb69c0#l549
-- 
Stefan Richter
-=====-==-=- =--- --=-=
http://arcgraph.de/sr/
