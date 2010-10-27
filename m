Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269Ab0J0Nbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:31:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56719 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761261Ab0J0Nbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nf6DWKAVmBIjZx2zN5hGZr/vke7uaw6+ThjExQ2jZ3YuQbe2cKVPqKI2fhh1um2187
         JaxKswbrob0iozeWLmC1lBBu8Y8WUnLvmg3kJrxX5pz4EzmRO9HcuN2yNvD2yK1yaHM7
         h8mYK2DpU01G8m9KpUm2ecbb4ExuvXjSVMgKE=
MIME-Version: 1.0
In-Reply-To: <20101026025608.23512.60938.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
	<20101026025608.23512.60938.stgit@warthog.procyon.org.uk>
Date: Wed, 27 Oct 2010 22:31:35 +0900
Message-ID: <AANLkTim80mTPKN7HFk0-H_C4xmg0ySt--gMX_L9_qQrc@mail.gmail.com>
Subject: Re: [Linux-am33-list] [PATCH 35/43] MN10300: And Panasonic AM34
 subarch and implement SMP
From: Suzuki Takashi <suzuki.takashi@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Oct 26, 2010 at 11:56 AM, David Howells <dhowells@redhat.com> wrote:
> From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
>
> Implement the Panasonic MN10300 AM34 CPU subarch and implement SMP support for
> MN10300.  Also implement support for the MN2WS0060 processor and the ASB2364
> evaluation board which are AM34 based.
>
> Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
(snip)
>  arch/mn10300/proc-mn2ws0050/Makefile               |    5
>  arch/mn10300/proc-mn2ws0050/include/proc/cache.h   |   48 +
>  arch/mn10300/proc-mn2ws0050/include/proc/clock.h   |   20
>  .../proc-mn2ws0050/include/proc/dmactl-regs.h      |  103 ++
>  .../proc-mn2ws0050/include/proc/intctl-regs.h      |   29 +
>  arch/mn10300/proc-mn2ws0050/include/proc/irq.h     |   49 +
>  .../proc-mn2ws0050/include/proc/nand-regs.h        |  120 ++
>  arch/mn10300/proc-mn2ws0050/include/proc/proc.h    |   18
>  .../mn10300/proc-mn2ws0050/include/proc/smp-regs.h |   51 +
>  arch/mn10300/proc-mn2ws0050/proc-init.c            |  134 ++

Are these specific to mn2ws0050 or common among AM34 based SoCs?
Please dig a proc- directory using proc- group name, not specific SoC name.

-- 
Suzuki Takashi
