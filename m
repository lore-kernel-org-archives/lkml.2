Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0GYIUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:20:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0GYIUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:20:35 -0400
Message-ID: <4C4BF3C2.1020009@kernel.org>
Date: Sun, 25 Jul 2010 10:20:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org> <4C4BF0D2.1070503@zytor.com>
In-Reply-To: <4C4BF0D2.1070503@zytor.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 25 Jul 2010 08:20:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/25/2010 10:07 AM, H. Peter Anvin wrote:
> Syslinux 4 supports it with full 64-bit capabilities.  SeaBIOS (used in
> Qemu/KVM) supports it, and I know at least some hardware/firmware RAID
> solutions support it; I recently got access to a 3 TB SATA drive but due
> to NDA requirements I can't reveal the results of that testing.

Hmmm... doesn't sound too bad then.  Is there an easy to test whether
64bit LBA works?  I have a 2.5TiB drive and can test the machines I
have and probably publish the result too.

Thanks.

-- 
tejun
