Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1DCJRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1DCJRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:17:48 -0400
Message-ID: <4D983B14.5050509@redhat.com>
Date: Sun, 03 Apr 2011 12:17:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D978930.1000909@codemonkey.ws> <BANLkTinAHh9m8BYUJZ7sFeX58cZnNySGDg@mail.gmail.com>
In-Reply-To: <BANLkTinAHh9m8BYUJZ7sFeX58cZnNySGDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 11:51 AM, Pekka Enberg wrote:
> Hi Anthony,
>
> On Sat, Apr 2, 2011 at 11:38 PM, Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >>  The goal of this tool is to provide a clean, from-scratch, lightweight
> >>  KVM host tool implementation that can boot Linux guest images (just a
> >>  hobby, won't be big and professional like QEMU) with no BIOS
> >>  dependencies and with only the minimal amount of legacy device
> >>  emulation.
> >
> >  I see you do provide 16-bit entry points for Linux.  Are you planning on
> >  paravirtualizing this within Linux to truly eliminate the BIOS dependency?
>
> No, we aren't planning that at the moment. We're trying to support
> out-of-the-box distro kernels when possible which is why we went for
> E820 emulation in the first place. The only hard requirement for
> bootung userspace is CONFIG_VIRTIO_BLK but otherwise kernel binaries
> should just work.
>
> Furthermore, as the BIOS glue is really really small, I'm not sure if
> we need to get rid of it completely. Do you have some scenario in mind
> where paravirt solution would help?

It would be a easier to support the bios than implement everything it 
provides in a different way.  SMP support, cpu hotplug, device hotplug, 
NUMA, and probably other features all rely on the bios.

-- 
error compiling committee.c: too many arguments to function

