Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1ASMPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:15:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53734 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1ASMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:15:24 -0500
Message-ID: <4D36D594.3010909@ru.mvista.com>
Date: Wed, 19 Jan 2011 15:14:12 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        John Linn <John.Linn@xilinx.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 8/8] arm/dt: Basic tegra devicetree support
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6> <20110118202938.13011.35918.stgit@localhost6.localdomain6>
In-Reply-To: <20110118202938.13011.35918.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-01-2011 23:29, Grant Likely wrote:

> This patch adds adds

    One word is enough. :-)

> very basic support for booting versatile with a
> device tree.  It simply allows the existing machine_descs to match
> against the tegra compatible values so that the kernel can boot.
> Kernel parameters and the initrd pointer is read out of the tree
> instead of atags.

> This is not complete device tree support.  This change will be
> reverted when a new machine_desc is added that can populate the
> versatile device registrations directly from data in the tree instead
> of using hard coded data.  That change will be made in a future patch.

> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>

WBR, Sergei
