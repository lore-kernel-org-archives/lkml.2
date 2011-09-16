Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1IPUAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 16:00:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39697 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1IPUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 16:00:52 -0400
Date: Fri, 16 Sep 2011 21:00:40 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Tzu-Jung Lee <roylee17@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tzu-Jung Lee <tjlee@ambarella.com>
Subject: Re: [PATCH] ARM: tlb: Compile out MULTI_TLB specific code when
	MULTI_TLB is undefined
Message-ID: <20110916200040.GA18566@flint.arm.linux.org.uk>
References: <1316190666-18905-1-git-send-email-tjlee@ambarella.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316190666-18905-1-git-send-email-tjlee@ambarella.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 12:31:06AM +0800, Tzu-Jung Lee wrote:
> To eliminate the 'undefined cpu_tlb' errors when the kernel is built with -O0

The kernel requires to be built with optimization in many places, and so
this is an option we don't support.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
