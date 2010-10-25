Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0JYSoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:44:18 -0400
Received: from verein.lst.de ([213.95.11.210]:41668 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492Ab0JYSoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:44:07 -0400
Date: Mon, 25 Oct 2010 20:44:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <error27@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] hfsplus: fix double lock typo in ioctl
Message-ID: <20101025184403.GA18094@lst.de>
References: <20101025045326.GW5985@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025045326.GW5985@bicker>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.285 () BAYES_44,MAILTO_TO_SPAM_ADDR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 06:53:27AM +0200, Dan Carpenter wrote:
> This was supposed to be a mutex_unlock() instead of a mutex_lock().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks,

applied.

