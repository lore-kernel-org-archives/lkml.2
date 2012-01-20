Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2ATRpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:45:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36329 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2ATRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:45:44 -0500
Date: Fri, 20 Jan 2012 09:45:37 -0800
From: Tejun Heo <htejun@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: AHCI_SHT(), ATA_BASE_SHT() and .can_queue
Message-ID: <20120120174537.GA4196@dhcp-172-17-108-109.mtv.corp.google.com>
References: <CAO+b5-rwSy9_7LmbNBKQPmYU8M5z48WRCV3tRSjeUnswPkT+Kw@mail.gmail.com>
 <20120120173604.GD3336@dhcp-172-17-108-109.mtv.corp.google.com>
 <CAO+b5-r=e_7ereoWbV2bMh+nApk2zeE9=yk=2eGQRhhZZsJVPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-r=e_7ereoWbV2bMh+nApk2zeE9=yk=2eGQRhhZZsJVPw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:38:45PM +0000, Bart Van Assche wrote:
> Unfortunately sparse complains about that construct. It is annoying
> when checking e.g. drivers/scsi with sparse to see sparse complain
> many times about two different values being specified for .can_queue.
> Should the sparse authors remove that warning ?

I really don't know.  Maybe sparse can provide explicit annotation
(e.g. multiple initializers for this struct is okay)?  Maybe we can
just exclude duplicate initializer check on the few affected files.
Or, we can just keep ignoring them.

Thanks.

-- 
tejun
