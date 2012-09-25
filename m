Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2IYS1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:27:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39765 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2IYS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:27:00 -0400
Date: Tue, 25 Sep 2012 11:26:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jongman Heo <jongman.heo@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1066 try_to_grab_pending
Message-ID: <20120925182655.GE16296@google.com>
References: <11797276.450191347588444054.JavaMail.weblogic@epml12>
 <20120925105147.GC5368@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925105147.GC5368@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:51:47PM +0300, Dan Carpenter wrote:
> Added Tejun to the CC list.
> 
> regards,
> dan carpenter
> 
> On Fri, Sep 14, 2012 at 02:07:24AM +0000, Jongman Heo wrote:
> > 
> > Hi Guys,
> > 
> > I hit this warning with current linus + for-next branch of wq.git, running Fedora 17 on VMWare linux guest.

The WARN is spurious.  Already removed in wq/for-3.7.  Forgot to push
out.

Thanks!

-- 
tejun
