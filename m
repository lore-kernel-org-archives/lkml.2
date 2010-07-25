Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0GYI1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:27:01 -0400
Received: from v-smtp-auth-relay-3.gradwell.net ([79.135.125.42]:37126 "EHLO
	v-smtp-auth-relay-3.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab0GYI07 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:26:59 -0400
Subject: Re: support for drives larger than 2TiB
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, Yuhong Bao <yuhongbao_386@hotmail.com>,
        jeff@garzik.org, ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
In-Reply-To: <4C4BF0D2.1070503@zytor.com>
References: <4C4AB952.9030705@kernel.org>
	 <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org>
	 <4C4BF0D2.1070503@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Sun, 25 Jul 2010 09:26:24 +0100
Message-ID: <1280046384.2139.0.camel@lithium.local.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-25 at 01:07 -0700, H. Peter Anvin wrote:
> 
> Syslinux 4 supports it with full 64-bit capabilities.  SeaBIOS (used
> in
> Qemu/KVM) supports it, and I know at least some hardware/firmware RAID
> solutions support it; I recently got access to a 3 TB SATA drive but
> due to NDA requirements I can't reveal the results of that testing. 

Yes but is it possible to boot from a complete 4k sector with the new
standards? 
-- 
http://www.munted.org.uk

One very high maintenance cat living here.
