Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1KHOra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:47:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55704 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab1KHOr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <20111108144345.7555fa01@x220>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
	<20111108144345.7555fa01@x220>
Date: Tue, 8 Nov 2011 22:47:26 +0800
Message-ID: <CACVXFVPLO_+-LwAGzooPALCUEEpvKDZuGm-T6C9FkPo46n63JQ@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
From: Ming Lei <tom.leiming@gmail.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 9:43 PM, Udo Steinberg <udo@hypervisor.org> wrote:
> On Mon, 7 Nov 2011 18:10:02 -0800 Linus Torvalds (LT) wrote:
>
> LT> Have fun, give it a good testing. There shouldn't be anything hugely
> LT> scary in there, but there *is* a lot of stuff. The fact that 3.1
> LT> dragged out did mean that this ended up being one of the bigger merge
> LT> windows, but I'm not feeling *too* nervous about it.
>
> Hi,
>
> The formatting of /proc/misc broke for cpu_dma_latency. This causes programs

The patch in blow link can fix the issue, maybe Rafael will push it out in -rc2.

http://marc.info/?l=linux-pm&m=132065404031749&w=2


> reading from /proc/misc to complain. For example:
>
> cryptsetup luksClose /dev/sdX
> /proc/misc: No entry for device-mapper found
> Is device-mapper driver missing from kernel?
>
> With Linux 3.2-rc1:
>  60 network_throughput
>  61 network_latency
>  62
> 236 device-mapper
> 237 loop-control
> 175 agpgart
> 144 nvram
> 231 snapshot
> 184 microcode
> 227 mcelog
>  63 vga_arbiter
>
> With Linux 3.1:
>  60 network_throughput
>  61 network_latency
>  62 cpu_dma_latency
> 236 device-mapper
> 237 loop-control
> 175 agpgart
> 144 nvram
> 231 snapshot
> 184 microcode
> 227 mcelog
>  63 vga_arbiter
>
> Cheers,
>
>        - Udo
>


thanks,
-- 
Ming Lei
