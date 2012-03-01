Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2CASqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:46:04 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45600 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2CASqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:46:03 -0500
Date: Thu, 1 Mar 2012 19:45:44 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120301184544.GA3391@aftab>
References: <4F4E1F91.9080705@redhat.com>
 <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com>
 <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
 <20120229171626.GJ21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
 <20120301112949.GA32410@aftab>
 <4F4F776B.90609@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F040AB7@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040AB7@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 06:15:46PM +0000, Luck, Tony wrote:
> > On all the above, the socket label starts on 1, but I bet we'll find cases
> > where it start from 0.
> 
> Agreed. "Socket Designation" seems to be a free format string at the whim of
> the board designer (and then interpreted and string filled in by a BIOS writer
> with all the usual caveats that implies).
> 
> I suppose a smart reporting system would try to query this stuff ahead of
> time to determine whether socket numbers were zero based, one based, or something
> else altogether (Socket A, B, C ????)

Query from where? (And pls don't tell me DMI tables. :-))

I don't think there's a mapping between board designer nomenclature and
BIOS values for the node ID you get from apic IDs and etc CPUID leafs.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
