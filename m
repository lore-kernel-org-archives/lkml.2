Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1AXPvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:51:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1AXPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rfTeeTUlmw59rZCd6aGQEbxz/TbDYtesmyZYCv7Sa/X4OQWNKv/yEJ0nqyyVnSwmj4
         paq4bOYAzvjqBIojr7ndGjcTmCzph12Ei1RTiGG/hHrQ4X8ATA3yyuaus9wd+N5978ge
         UOxJyEFh4ZUi1Vr6lcb11us7WCwjadsdd1l8w=
Date: Mon, 24 Jan 2011 16:51:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>, Jan Beulich <JBeulich@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pcifront: don't use flush_scheduled_work()
Message-ID: <20110124155133.GA27510@htj.dyndns.org>
References: <20110124144303.GG11404@htj.dyndns.org>
 <20110124153958.GA1222@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124153958.GA1222@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 24, 2011 at 10:39:58AM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 24, 2011 at 03:43:03PM +0100, Tejun Heo wrote:
> > flush_scheduled_work() is scheduled for deprecation.  Cancel ->op_work
> 
> 2.6.39 or 2.6.40? Not seeing it referenced in
> feature-removal-schedule.txt file?

There now are only a handful of users left.  I'm currently sending out
patches for them.  Once they appear on linux-next, I'll mark
flush_scheduled_work() deprecated and add it to feature-removal in the
workqueue tree and push it to linux-next.  So, yeah, it's likely to be
marked deprecated in 2.6.39.

Thanks.

-- 
tejun
