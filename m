Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0IGMTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:47758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab0IGMTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:19:46 -0400
Message-ID: <4C862DDC.6010702@kernel.org>
Date: Tue, 07 Sep 2010 14:19:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de>
In-Reply-To: <20100907121608.GA26597@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Sep 2010 12:19:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/07/2010 02:16 PM, Christoph Hellwig wrote:
> What does this conversion buy us?
> 
> Having explicit per-bdi threads makes the model very simple and safe,
> while I don't quite trust the now extremly complex work queues yet.

Well, the whole idea behind the new workqueue is unifying all those
dedicated pools of threads.  If the conversion is too early given the
new workqueue implementation, we can postpone bdi conversion by one
more release cycle, but in the long run there is no point in keeping
these private thread pools.

Thanks.

-- 
tejun
