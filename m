Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab0J1UOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:14:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36079 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab0J1UOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:14:34 -0400
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288294355.11251.20.camel@localhost.localdomain>
References: <1288216693.17571.38.camel@localhost.localdomain>
	 <1288240804.14342.1.camel@localhost.localdomain>
	 <20101028052021.GD5599@redhat.com>
	 <1288294355.11251.20.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 13:13:55 -0700
Message-ID: <1288296835.11251.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 12:32 -0700, Shirley Ma wrote:
> Also I found a big TX regression for old guest and new guest. For old
> guest, I am able to get almost 11Gb/s for 2K message size, but for the
> new guest kernel, I can only get 3.5 Gb/s with the patch and same
> host.
> I will dig it why. 

The regression is from guest kernel, not from this patch. Tested 2.6.31
kernel, it's performance is less than 2Gb/s for 2K message size already.
I will resubmit the patch for review. 

I will start to test from 2.6.30 kernel to figure it when TX regression
induced in virtio_net. Any suggestion which guest kernel I should test
to figure out this regression?

Thanks
Shirley

