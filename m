Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0IMSsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:48:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36394 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0IMSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:48:13 -0400
Subject: Re: [RFC PATCH v9 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <20100903105233.GA32193@redhat.com>
References: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
	 <1281489804.3391.23.camel@localhost.localdomain>
	 <1281490993.3391.25.camel@localhost.localdomain>
	 <1281506460.3391.42.camel@localhost.localdomain>
	 <1281509704.3391.45.camel@localhost.localdomain>
	 <20100903105233.GA32193@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 11:48:08 -0700
Message-ID: <1284403688.13351.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 13:52 +0300, Michael S. Tsirkin wrote:
> Could you look at the guest as well?

I just finished the patch built against the recent kernel. I will submit
perf data for both guest, host along with the patch.

Thanks
Shirley

