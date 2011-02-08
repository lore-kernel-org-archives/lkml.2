Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1BHNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:49:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57305 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHNtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:49:20 -0500
Date: Tue, 8 Feb 2011 14:49:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: martin f krafft <madduck@madduck.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Opteron ECC/ChipKill error
Message-ID: <20110208134910.GA3849@kryptos.osrc.amd.com>
References: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 02:30:11PM +0100, martin f krafft wrote:
> Dear list,
> 
> I just got to see the following message on my Opteron server:
> 
>   kernel: [810137.744689]  Northbridge Error, node 1
>   kernel: [810137.756250] ECC/ChipKill ECC error.
>   kernel: [810137.766975] EDAC amd64 MC1: CE ERROR_ADDRESS= 0x26bdd40f0
>   kernel: [810137.766982] EDAC MC1: CE page 0x26bdd4, offset 0xf0, grain 0, syndrome 0xe1e2, row 6, channel 1, label "": amd64_edac
> 
> Is there any way to deduce from these data the actual
> culprit/component to replace?

It is a DRAM ECC error on one of the DIMMs on your node 1. If it is a
single occurrence I wouldn't start to worry yet - I'd monitor to see
whether the same row above (row 6) starts increasing its error rate.
Also, sometimes reseating the DIMMs helps.

Can you send your dmesg please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
