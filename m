Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0GLFxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 01:53:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51144 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0GLFx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 01:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jaJzEiwx6JaMnNa2by1roTKGWduu5HGeZDOz8O2RQfZ8XR5Ir6/1bmq8okXgbFL+tI
         TRrjEKe+5xpVZ6hmoKhDJXIbjPbTlZVKqzM+WVD3B9s6/9jtcbBahZ/9oOa5nC/PIV4u
         RbQFevsCiZWfGPCqIBMhcHlNsaD4V24EUDi+U=
Message-ID: <4C3AAE04.8060309@gmail.com>
Date: Sun, 11 Jul 2010 22:54:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
In-Reply-To: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2010 10:24 PM, Giangiacomo Mariotti wrote:
> Hi, is it a known problem how much slow is Btrfs with kvm/qemu(meaning
> that the image kvm/qemu uses as the hd is on a partition formatted
> with Btrfs, not that the fs used by the hd inside the kvm environment
> is Btrfs, in fact inside kvm the / partition is formatted with ext3)?
> I haven't written down the exact numbers, because I forgot, but while
> I was trying to make it work, after I noticed how much longer than
> usual it was taking to just install the system, I took a look at iotop
> and it was reporting a write speed of the kvm process of approximately
> 3M/s, while the Btrfs kernel thread had an approximately write speed
> of 7K/s! Just formatting the partitions during the debian installation
> took minutes. When the actual installation of the distro started I had
> to stop it, because it was taking hours! The iotop results made me
> think that the problem could be Btrfs, but, to be sure that it wasn't
> instead a kvm/qemu problem, I cut/pasted the same virtual hd on an
> ext3 fs and started kvm with the same parameters as before. The
> installation of debian inside kvm this time went smoothly and fast,
> like normally it does. I've been using Btrfs for some time now and
> while it has never been a speed champion(and I guess it's not supposed
> to be one and I don't even really care that much about it), I've never
> had any noticeable performance problem before and it has always been
> quite stable. In this test case though, it seems to be doing very bad.
>
> cheers
>

not sure with butter filesystems.. but, what is the last good kernel? 
are you able to bisect?

Justin P. Mattock
