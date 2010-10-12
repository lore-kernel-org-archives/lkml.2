Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0JLQQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:16:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44340 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab0JLQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:16:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB489B7.2080808@s5r6.in-berlin.de>
Date: Tue, 12 Oct 2010 18:15:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect,
 and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org> <tkrat.1386de42b88d7218@s5r6.in-berlin.de> <tkrat.dd9197843f6a0a54@s5r6.in-berlin.de> <4CB468C1.8000004@kernel.org>
In-Reply-To: <4CB468C1.8000004@kernel.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Hejo wrote:
> It doesn't have to be swap.  Having a rw filesystem mounted is enough
> to be in the memory reclaim path.

Oh, alright.

...
> Yes, it would definitely be better to put them in a workqueue with
> WQ_RESCUER (or the new WQ_MEM_RECLAIM).

A pro pos WQ_MEM_RECLAIM, is wq.git#for-next stable history which I can pull
into a topic branch at linux1394-2.6.git?  (Or I wait with this stuff until
after .37-rc1.)
-- 
Stefan Richter
-=====-==-=- =-=- -==--
http://arcgraph.de/sr/
