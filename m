Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0C3HFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:05:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37340 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0C3HFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:05:07 -0400
Date: Tue, 30 Mar 2010 09:05:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDAC: Is it possible to calculate which piece of memory is bad?
Message-ID: <20100330070544.GA19488@aftab>
References: <alpine.DEB.2.00.1003290939340.27175@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003290939340.27175@p34.internal.lan>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Mon, Mar 29, 2010 at 09:40:38AM -0400

> Hello,
> 
> I see the following errors:
> 
> EDAC MC0: CE page 0x8abba, offset 0xa10, grain 8, syndrome 0x4758, row 0, channel 0, label "": k8_edac

It looks like it is the first DIMM on your mainboard, i.e., whichever
gets mapped to channel 0 of the DCT.

Sigh, someday we'll have a better mapping, hopefully, ... :|

> EDAC MC0: CE - no information available: k8_edac Error Overflow set
> EDAC k8 MC0: extended error code: ECC chipkill x4 error
> EDAC k8 MC0: general bus error: participating processor(local node origin), time-out(no timeout) memory transaction type(generic read), mem or i/o(mem access), cache level(generic)
> 
> Is it possible to use the page or offset to calculate which DIMM is having a
> problem?


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
