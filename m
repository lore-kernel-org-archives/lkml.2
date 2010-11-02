Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0KBInE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:43:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64509 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0KBIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:42:56 -0400
Message-ID: <4CCFCF0B.9010507@monstr.eu>
Date: Tue, 02 Nov 2010 09:42:51 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        monstr@monstr.eu, tglx@linutronix.de, davem@davemloft.net
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] xilinx_emaclite: netpoll support
References: <tip-357e8b5f723ba9e1d0a0f8ffb1361d607e43e19a@git.kernel.org>
In-Reply-To: <tip-357e8b5f723ba9e1d0a0f8ffb1361d607e43e19a@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Michal Simek wrote:
> Commit-ID:  357e8b5f723ba9e1d0a0f8ffb1361d607e43e19a
> Gitweb:     http://git.kernel.org/tip/357e8b5f723ba9e1d0a0f8ffb1361d607e43e19a
> Author:     Michal Simek <monstr@monstr.eu>
> AuthorDate: Wed, 18 Aug 2010 01:22:49 +0000
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Thu, 19 Aug 2010 00:49:47 -0700
> 
> xilinx_emaclite: netpoll support
> 
> Netconsole requires poll support.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/xilinx_emaclite.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)

It is in the mainline.

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
