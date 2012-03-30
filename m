Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab2C3C7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:59:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759709Ab2C3C7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:59:42 -0400
X-IronPort-AV: E=Sophos;i="4.75,340,1330876800"; 
   d="scan'208";a="4654187"
Date: Fri, 30 Mar 2012 10:58:50 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v5 0/3] virtio-scsi driver
Message-ID: <20120330025850.GA6448@localhost.localdomain>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 10:55:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 10:57:24,
	Serialize complete at 2012-03-30 10:57:24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

The same bug I found in v3 is still in v5. please refer to this mail: 
https://lkml.org/lkml/2012/3/10/207

-- 
Thanks,
Hu Tao
