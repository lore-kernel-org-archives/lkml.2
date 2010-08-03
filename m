Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0HCPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:50:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55204 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0HCPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:50:36 -0400
Subject: RE: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D791BAB307B7E@shsmsx502.ccr.corp.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <F2E9EB7348B8264F86B6AB8151CE2D791BAB307B7E@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 08:50:20 -0700
Message-ID: <1280850620.3391.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xiaohui,

On Tue, 2010-08-03 at 16:48 +0800, Xin, Xiaohui wrote:
> May you share me with your performance results (including BW and
> latency)on 
> vhost-net and how you get them(your configuration and especially with
> the affinity 
> settings)? 

My macvtap zero copy is incomplete, I am testing sendmsg only now. The
initial performance is not good especially for latency (zero copy vs.
copy). I am still working on it to find out why and how to improve.
That's the reason I am eager to know your performance results and how
much performance gain you have seen.

Since your patch has completed. I would try your patch here for
performance. If you have some performance results to share here that
would be great.

Thanks
Shirley

