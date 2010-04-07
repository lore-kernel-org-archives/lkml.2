Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0DGHDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:03:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38237 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0DGHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:02:55 -0400
Date: Wed, 7 Apr 2010 09:02:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [tip:core/hweight] x86: Add optimized popcnt variants
Message-ID: <20100407070201.GA11384@aftab>
References: <20100318112015.GC11152@aftab>
 <tip-d61931d89be506372d01a90d1755f6d0a9fafe2d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d61931d89be506372d01a90d1755f6d0a9fafe2d@git.kernel.org>
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

From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, Apr 06, 2010 at 11:04:07PM +0000

> Commit-ID:  d61931d89be506372d01a90d1755f6d0a9fafe2d
> Gitweb:     http://git.kernel.org/tip/d61931d89be506372d01a90d1755f6d0a9fafe2d
> Author:     Borislav Petkov <borislav.petkov@amd.com>
> AuthorDate: Fri, 5 Mar 2010 17:34:46 +0100
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Tue, 6 Apr 2010 15:52:11 -0700

Just so you know, Andrew picked those up already, along with Peter's
multi-arch-touching patch.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
