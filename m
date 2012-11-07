Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2KGXis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:38:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2KGXir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:38:47 -0500
X-IronPort-AV: E=Sophos;i="4.80,734,1344182400"; 
   d="scan'208";a="6157069"
Message-ID: <509AF10B.1060100@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 07:38:51 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] virtio-scsi: create a separate workqueue
References: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
In-Reply-To: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 07:37:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 07:37:50,
	Serialize complete at 2012/11/08 07:37:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 06:12 AM, Paolo Bonzini wrote:
>> patch 1-3,5 are some cleanups.
>> patch 4: create a separate work queue for virtio-scsi
>> to improve the performance, I tested with tmpfs backed
>> disk, the config file is like below,
> 
> I think something else caused the improvement, because the code you
> touched (complete_event) shouldn't ever run during a normal benchmark.
> It's only used for hotplug/hot-unplug.
> 
> Nevertheless, I'll queue the cleanup patches.  Thanks for those.

Oops, got it, I will investigate more. Thank you for teaching me.

Regards,
Wanlong Gao

