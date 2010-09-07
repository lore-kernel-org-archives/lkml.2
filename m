Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0IGMQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:16:17 -0400
Received: from verein.lst.de ([213.95.11.210]:47377 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab0IGMQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:16:14 -0400
Date: Tue, 7 Sep 2010 14:16:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with workqueue
Message-ID: <20100907121608.GA26597@lst.de>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What does this conversion buy us?

Having explicit per-bdi threads makes the model very simple and safe,
while I don't quite trust the now extremly complex work queues yet.

