Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0J2ING (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0J2INA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:13:00 -0400
Date: Fri, 29 Oct 2010 10:12:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
Message-ID: <20101029081256.GD22688@redhat.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
 <1288240804.14342.1.camel@localhost.localdomain>
 <20101028052021.GD5599@redhat.com>
 <1288294355.11251.20.camel@localhost.localdomain>
 <1288296835.11251.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288296835.11251.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 01:13:55PM -0700, Shirley Ma wrote:
> On Thu, 2010-10-28 at 12:32 -0700, Shirley Ma wrote:
> > Also I found a big TX regression for old guest and new guest. For old
> > guest, I am able to get almost 11Gb/s for 2K message size, but for the
> > new guest kernel, I can only get 3.5 Gb/s with the patch and same
> > host.
> > I will dig it why. 
> 
> The regression is from guest kernel, not from this patch. Tested 2.6.31
> kernel, it's performance is less than 2Gb/s for 2K message size already.
> I will resubmit the patch for review. 
> 
> I will start to test from 2.6.30 kernel to figure it when TX regression
> induced in virtio_net. Any suggestion which guest kernel I should test
> to figure out this regression?
> 
> Thanks
> Shirley

git bisect 2.6.31 2.6.30
and go from here.
