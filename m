Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1DZHuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:50:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33907 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab1DZHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dJzDUXeC3qdNcyuBqof8FKTP7IZwKBBEZEZseTLywa+ZsPUldDsG+TtbBjbJT55xJS
         p8Q/MsrXP+TEkO3igS3LNpwcnSKj32ZBVCp/FPfNasa8OkO4wG0ljyFuJvdu7eTGHjWL
         4Co405Bm7rPRzW/NxmIjqsVHGy6sk1pde5JbQ=
Message-ID: <4DB67935.8050104@gmail.com>
Date: Tue, 26 Apr 2011 15:50:13 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio, ring: Use ALIGN macros in virtio_ring.h
References: <1303791070-15196-1-git-send-email-namei.unix@gmail.com> <20110426074230.GA10364@redhat.com>
In-Reply-To: <20110426074230.GA10364@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 03:42 PM, Michael S. Tsirkin wrote:
> On Tue, Apr 26, 2011 at 12:11:10PM +0800, Liu Yuan wrote:
>> From: Liu Yuan<tailai.ly@taobao.com>
>>
>>
>> Signed-off-by: Liu Yuan<tailai.ly@taobao.com>
> Issue is, these functions are exported to userspace,
> which does not have these macros.
>
Ah, thanks, I should have noticed the '#ifdef __KERNEL__' just below the 
lines I touched.

Thanks,
Yuan
