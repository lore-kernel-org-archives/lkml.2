Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2ILKob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:44:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59388 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2ILKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:44:23 -0400
Message-ID: <5050679F.9030002@gmail.com>
Date: Wed, 12 Sep 2012 12:44:47 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Thomas Lendacky <tahm@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120906084526.GE17656@redhat.com> <87txvahfv3.fsf@rustcorp.com.au> <14037987.hiN6MSGY6z@tomlt1.ibmoffice.com> <87bohbdb0o.fsf@rustcorp.com.au>
In-Reply-To: <87bohbdb0o.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 08:13 AM, Rusty Russell wrote:
> The real question is now whether we'd want a separate indirect cache for
> the 3 case (so num above should be a bitmap?), or reuse the same one, or
> not use it at all?
> 
> Benchmarking will tell...

Since there are no specific decisions about actual values, I'll just modify the
code to use cache per-vq instead of per-device.


Thanks,
Sasha
