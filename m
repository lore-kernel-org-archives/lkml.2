Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2FZPnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:43:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab2FZPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:43:44 -0400
Message-ID: <4FE9D8AC.6010809@twiddle.net>
Date: Tue, 26 Jun 2012 08:43:40 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] alpha/PCI: Factor 'pcibios_setup()' out of alpha
References: <20120626033045.16434.17412.stgit@amt.stowe> <20120626033109.16434.92644.stgit@amt.stowe>
In-Reply-To: <20120626033109.16434.92644.stgit@amt.stowe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 08:31 PM, Myron Stowe wrote:
> The PCI core provides a generic (__weak) 'pcibios_setup()' routine
> that can be used by all architectures as a default.  Drop alpha's
> architecture specific version in favor of that as it does not need to be
> over-ridden.
> 
> No functional change.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
> 
>  arch/alpha/kernel/pci.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)

Acked-by: Richard Henderson <rth@twiddle.net>


r~
