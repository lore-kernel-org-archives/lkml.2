Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2GaOym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2GaOya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:54:30 -0400
Message-ID: <5017F19E.4070308@redhat.com>
Date: Tue, 31 Jul 2012 17:54:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag>
In-Reply-To: <5017C8A0.60506@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 02:59 PM, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> i hope it is correct to list the maintainers of kvm. While trying to
> install ubuntu 12.04 amd64 on a kvm based vm the KVM process segfaults
> while ubuntu tries to detect the HW:
> kvm[2978]: segfault at 7fb90d9035e0 ip 00007fb90d9035e0
> sp00007fff652e4ed8 error 15
> 
> This does not happen with a rhel6 based 2.6.32 kernel so i thought this
> must be a bug in vanilla 3.5.0 kernel.
> 
> Is this known? What information do you need?
> 

Please build qemu with debug information, generate a core, and post a
backtrace.

-- 
error compiling committee.c: too many arguments to function


