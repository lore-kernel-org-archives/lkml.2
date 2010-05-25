Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0EYGVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0EYGVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:21:05 -0400
Date: Tue, 25 May 2010 09:21:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Orion Poplawski <orion@cora.nwra.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Clock jumps
Message-ID: <20100525062100.GP22163@redhat.com>
References: <loom.20100524T171038-56@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20100524T171038-56@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kvm to CC.

On Mon, May 24, 2010 at 04:06:32PM +0000, Orion Poplawski wrote:
> I have a KVM virtual machine running 2.6.33.4-95.fc13.x86_64 on a CentOS 5.5
> host whose clock jumps about 8-12 hours a couple times a day.  I have no idea
> what is causing it.  Fedora 12 and Centos 5.5 KVM machines run fine on the same
> host.  Is there any debugging I can enable to see what is jumping the clock?
> 
> kvm-clock: cpu 0, msr 0:1ba4741, boot clock
> kvm-clock: cpu 0, msr 0:1e15741, primary cpu clock
> Switching to clocksource kvm-clock
> rtc_cmos 00:01: setting system clock to 2010-05-20 16:59:48 UTC (1274374788)
> 
> Thanks,
> 
>  Orion
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
