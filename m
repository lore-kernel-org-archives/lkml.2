Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0ERIp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:45:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54391 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0ERIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:45:56 -0400
Date: Tue, 18 May 2010 10:45:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com, andi@firstfloor.org,
       Linus Torvalds <torvalds@linux-foundation.org>, alain@knaff.lu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100518084551.GA22675@basil.fritz.box>
References: <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com> <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <20100517145943.GV5888@alberich.amd.com> <4BF1E5BE.9010000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF1E5BE.9010000@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If one wanted, you could disable HPET MSI on this chipset only when a 
> driver requests an ISA DMA channel. Then if there's no floppy or other LPC 
> DMA device present, it can stay enabled. I don't know if it's worth the 
> trouble, though.

There can be LPC devices which are not visible to the kernel,
but only used through ACPI or the BIOS. Think of fancy fan
controllers and similar.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
