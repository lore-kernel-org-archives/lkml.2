Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BLMQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 07:16:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1BLMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 07:16:19 -0500
Date: Sat, 12 Feb 2011 12:16:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca
Subject: Re: [PATCH V2 3/4] ARM: Xilinx: base header files and assembly
	macros
Message-ID: <20110212121609.GI15616@n2100.arm.linux.org.uk>
References: <1297270845-18802-1-git-send-email-john.linn@xilinx.com> <1297270845-18802-2-git-send-email-john.linn@xilinx.com> <1297270845-18802-3-git-send-email-john.linn@xilinx.com> <e19bc079-5f8a-4622-b7cd-668cede3cb97@VA3EHSMHS032.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e19bc079-5f8a-4622-b7cd-668cede3cb97@VA3EHSMHS032.ehs.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:00:44AM -0700, John Linn wrote:
> +#ifndef __MACH_VMALLOC_H__
> +#define __MACH_VMALLOC_H__
> +
> +#define VMALLOC_END       0xE0000000

Should have a UL suffix on this.
