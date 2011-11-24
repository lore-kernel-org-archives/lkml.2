Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1KXHzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:55:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:56020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1KXHzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:55:31 -0500
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com>
Date: Thu, 24 Nov 2011 01:55:16 -0600
Cc: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DF5BDBFF-A726-4E1C-832E-EF2629F60DC9@kernel.crashing.org>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net> <4EBD4FB8.2020406@freescale.com> <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net> <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 15, 2011, at 9:02 PM, Tabi Timur-B04825 wrote:

> On Mon, Nov 14, 2011 at 2:55 AM, Kokoris, Ioannis
> <ioannis.kokoris@siemens-enterprise.com> wrote:
>> Ready register is needed for ROM-less devices such as P1021, MPC859, MPC8306 etc.
>> For ROM-based devices such as MCP8323 the Ready register does not exist.
>> Is there a global definition for conditionally including this code?
> 
> I'll have to check.  But this patch can't be applied as-is unless it's
> proven safe for all QE-enabled chips.

Any update on trying this on a MPC8323?

- k