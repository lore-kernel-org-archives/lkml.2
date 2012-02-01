Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2BAIVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:21:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab2BAIVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:21:32 -0500
Message-ID: <4F28F603.50104@redhat.com>
Date: Wed, 01 Feb 2012 09:21:23 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com> <4F26596B.6030703@redhat.com> <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com> <4F28F42A.1050103@redhat.com> <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 09:18 AM, Pekka Enberg wrote:
>>>
>>
>> Of course.  I would have proposed it for staging otherwise.
>
> I'm not a SCSI expert but FWIW I went through the patches and I think
> they're definitely worthwhile having in mainline for v3.4:
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks Pekka!

Actually we had a conflict on the virtio id, so I'll have to respin with 
the id changed to 8.

Paolo
