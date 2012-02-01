Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2BAIS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:18:56 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42590 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793Ab2BAISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:18:55 -0500
Date: Wed, 1 Feb 2012 10:18:48 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Paolo Bonzini <pbonzini@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
In-Reply-To: <4F28F42A.1050103@redhat.com>
Message-ID: <alpine.LFD.2.02.1202011017200.7303@tux.localdomain>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com> <4F26596B.6030703@redhat.com> <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com> <4F28F42A.1050103@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Paolo Bonzini wrote:
>> Have the virtio specification changes been reviewed? Can we guarantee
>> stable ABI for the virtio-scsi driver?
>
> Of course.  I would have proposed it for staging otherwise.

I'm not a SCSI expert but FWIW I went through the patches and I think 
they're definitely worthwhile having in mainline for v3.4:

Acked-by: Pekka Enberg <penberg@kernel.org>

 			Pekka
