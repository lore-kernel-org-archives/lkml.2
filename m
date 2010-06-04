Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0FDBlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:41:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56443 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab0FDBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:41:12 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Fri, 4 Jun 2010 09:40:48 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1275479804.137633.565764505843.0.gpush@pororo> <201006031824.53832.jeremy.kerr@canonical.com> <20100603110533.GB7127@n2100.arm.linux.org.uk>
In-Reply-To: <20100603110533.GB7127@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006040940.51776.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> Or to put it another way, the above method results in clk_enable()
> sometimes returning with the clock enabled and sometimes with the
> clock still disabled.
> 
> That's not nice behaviour for drivers which may need the clock enabled
> to read/write the device registers.

OK, I'll rework with proper locking to ensure that the clock is 
enabled/disabled on return from clk_enable.

Cheers,


Jeremy
