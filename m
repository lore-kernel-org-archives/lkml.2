Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1I3DHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab1I3DHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:07:42 -0400
Date: Fri, 30 Sep 2011 08:36:59 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 02/11] virtio-pci: add PM notification handlers for
 restore, freeze, thaw, poweroff
Message-ID: <20110930030659.GA25524@amit-x200.redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <9f89dedd5e4e77c9244afde0ce22c1216a35c193.1317309123.git.amit.shah@redhat.com>
 <1317321398.21918.7.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317321398.21918.7.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 29 Sep 2011 [21:36:38], Sasha Levin wrote:
> 
> After drv->freeze() completes, the vq is freed from guest memory, but is
> there anything that prevents from the device to keep writing into that
> vq?
> 
> Shouldn't we set status to '0' before we free vqs?

Yes, this should be done in the driver code though, not in common
code.  I've fixed this in my tree.

Thanks,

		Amit
