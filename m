Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0DGCmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:42:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:54736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0DGCl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,376,1267430400"; 
   d="scan'208";a="555624365"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@c2.user-mode-linux.org" <jdike@c2.user-mode-linux.org>,
       "yzhao81@gmail.com" <yzhao81@gmail.com>
Date: Wed, 7 Apr 2010 10:41:08 +0800
Subject: RE: [PATCH 1/3] A device for zero-copy based on KVM virtio-net.
Thread-Topic: [PATCH 1/3] A device for zero-copy based on KVM virtio-net.
Thread-Index: AcrRjDzWloLq/tseTwCC82REc7j2hQEbxINg
Message-ID: <97F6D3BD476C464182C1B7BABF0B0AF5C183234A@shzsmsx502.ccr.corp.intel.com>
References: <20100308112849.GI7482@redhat.com>
 <1270114038-5048-1-git-send-email-xiaohui.xin@intel.com>
 <20100401110841.GE3323@redhat.com>
In-Reply-To: <20100401110841.GE3323@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,
 
>> Qemu needs a userspace write, is that a synchronous one or
>>asynchronous one?

>It's a synchronous non-blocking write.
Sorry, why the Qemu live migration needs the device have a userspace write?
how does the write operation work? And why a read operation is not cared here?

Thanks
Xiaohui
