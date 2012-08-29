Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2H2UqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 16:46:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44062 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2H2UqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 16:46:04 -0400
Message-ID: <503E7F9B.8010402@gmail.com>
Date: Wed, 29 Aug 2012 22:46:19 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120829153812.GD7407@redhat.com> <503E4DD9.1020102@gmail.com> <20120829181235.GE7877@redhat.com>
In-Reply-To: <20120829181235.GE7877@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 08:12 PM, Michael S. Tsirkin wrote:
>>> > > What is a good default for net? I guess max sg?
>> > 
>> > I think that it depends on the workload. I'd say we should keep the default to 0
>> > (disabled) unless we can have a good way to adjust it to the load.
> For *all* drivers?
> 
> Then it is mostly useless. No one has the time to tweak module
> parameters in real life.
> 
> For virtio-net, 16+1 is not too much and ensures we always
> use the cache.
> 
> If that works better than 0 I would say run with 17.

I was being extra-cautious with leaving it disabled until specifically enabled
because I assumed that this would be one of the first comments I'll get if it
was enabled by default :)

If you're comfortable with setting it to a sane default like 17, I'm perfectly
fine with that as well.


Thanks,
Sasha

