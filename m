Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0CXBR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:17:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0CXBR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:17:27 -0400
Date: Tue, 23 Mar 2010 21:17:15 -0400
From: Josef Bacik <josef@redhat.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       viro@ZenIV.linux.org.uk, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
	ioctl
Message-ID: <20100324011714.GA5658@localhost.localdomain>
References: <20100323142200.GA2381@localhost.localdomain> <4BA93FE3.9020502@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA93FE3.9020502@crca.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 09:25:39AM +1100, Nigel Cunningham wrote:
> Hi.
>
> A cc would have been nice :)
>
> Thankfully the subject caught my eye.
>

Well it's not really tux-on-ice's fault, freeze wouldn't work _at all_ via the
ioctl or any other method, we just happened to notice it was broken because
people using tux-on-ice were getting corrupt filesystems after suspend :).  Btw,
it may be good to have freezer_sync set to 1 by default, otherwise if an fs
doesnt support freezing it will likely end up corrupted too.  Thanks,

Josef
