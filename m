Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1DXIqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 04:46:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38931 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1DXIqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 04:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N0/Qsw1jJWrc8r2QmLlTvEWyQmTl1Szjx9Kyz93wR+h1ivYyixmpulOY6xv/m0Q62U
         lst44LxfuPI5JpilT95NT8Dx1rn9yShhR0ecJiB4QE+Gi+8hfSKEc+o4Il/9a3n75P9w
         C78oHDxFkLhiy6iX1VuM0ZmrbMQh31EZH4w6c=
MIME-Version: 1.0
In-Reply-To: <201104241022.17009.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
	<1303566747.12067.10.camel@localhost.localdomain>
	<201104241016.22639.chris@csamuel.org>
	<201104241022.17009.chris@csamuel.org>
Date: Sun, 24 Apr 2011 01:46:03 -0700
X-Google-Sender-Auth: fad39mphZGAsqIgVN555_H0WR1g
Message-ID: <BANLkTi=jKhd5foP=Avdv4cGUntbSMSDZrg@mail.gmail.com>
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
From: Yinghai Lu <yinghai@kernel.org>
To: Chris Samuel <chris@csamuel.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Yuhong Bao <yuhongbao_386@hotmail.com>,
        hpa@zytor.com, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 5:22 PM, Chris Samuel <chris@csamuel.org> wrote:
> On Sun, 24 Apr 2011 10:16:22 AM Chris Samuel wrote:
>
>> A fuller kernel does proceed further than before, before running
>> into issues where both the e100 and aix7xxx drivers complain about
>> not being able to find their IRQ's and that this might be due to
>> a buggy MP table.
>
> Booting with noapic nolapic removes the IRQ warning but the
> system still times out trying to mount the root filesystem and
> reboots itself.

You may need to your .config to have
CONFIG_SMP
CONFIG_PCI
CONFIG_X86_MPPARSE
set to use mptable from BIOS.

Thanks

Yinghai
