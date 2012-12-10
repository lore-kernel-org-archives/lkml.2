Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2LJNVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:21:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57586 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJNVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:21:48 -0500
Date: Mon, 10 Dec 2012 13:20:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Mircea Gherzan <mgherzan@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: net: bpf_jit_32: fix kzalloc gfp/size
	mismatch.
Message-ID: <20121210132002.GJ14363@n2100.arm.linux.org.uk>
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr> <50C2760A.9070406@gmail.com> <50C5E143.4070306@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5E143.4070306@freebox.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 02:18:59PM +0100, Nicolas Schichan wrote:
> On 12/08/2012 12:04 AM, Mircea Gherzan wrote:
>> Am 06.12.2012 15:38, schrieb Nicolas Schichan:
> [...]
>> Acked-by: Mircea Gherzan<mgherzan@gmail.com>
>
> Hi,
>
> Thanks for acking those two patches.
>
> Shall I send them to the patch system now ?

Yes please.
