Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0JKTFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:05:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37505 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0JKTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:05:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB35FE1.90103@s5r6.in-berlin.de>
Date: Mon, 11 Oct 2010 21:05:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: core: use non-reentrant workqueue where necessary
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <4CB3113E.1060403@kernel.org>
In-Reply-To: <4CB3113E.1060403@kernel.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> For the workqueue part,
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks for looking at it.  (And for pointing out the reentrance issue with the
original system workqueue earlier during the cmwq postings.)
-- 
Stefan Richter
-=====-==-=- =-=- -=-==
http://arcgraph.de/sr/
