Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1ACUHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:07:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49632
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab1ACUHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:07:21 -0500
Date: Mon, 03 Jan 2011 12:07:52 -0800 (PST)
Message-Id: <20110103.120752.15260093.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ll_temac: Fix section mismatch from the temac_of_probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110103170332.GB2522@angua.secretlab.ca>
References: <1294050756-31099-1-git-send-email-monstr@monstr.eu>
	<20110103170332.GB2522@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 3 Jan 2011 10:03:32 -0700

> On Mon, Jan 03, 2011 at 11:32:36AM +0100, Michal Simek wrote:
>> Replace __init by __devinit.
>> 
>> Warning message:
>> WARNING: vmlinux.o(.data+0xbc14): Section mismatch in reference from the variable
>> temac_of_driver to the function .init.text:temac_of_probe()
>> The variable temac_of_driver references
>> the function __init temac_of_probe()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
>> 
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks everyone.
