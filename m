Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423006Ab2CPPY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:24:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:53212 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032852Ab2CPPYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:24:54 -0400
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <0154F680-D9F4-4CE1-BF5E-11884AD0ED4A@freescale.com>
Date: Fri, 16 Mar 2012 10:21:12 -0500
Cc: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AC087E7A-B7BC-43E5-948F-68AEB8251FD3@kernel.crashing.org>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net> <4EBD4FB8.2020406@freescale.com> <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net> <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com> <DF5BDBFF-A726-4E1C-832E-EF2629F60DC9@kernel.crashing.org> <0154F680-D9F4-4CE1-BF5E-11884AD0ED4A@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 24, 2011, at 7:57 AM, Tabi Timur-B04825 wrote:

> On Nov 24, 2011, at 1:55 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> 
>>> 
>>> I'll have to check.  But this patch can't be applied as-is unless it's
>>> proven safe for all QE-enabled chips.
>> 
>> Any update on trying this on a MPC8323?
> 
> Haiying said it should be ok, but I haven't tried it yet.  I'll try it on Monday.

Did you ever test this?

- k