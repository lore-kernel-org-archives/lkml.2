Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857Ab2FDQAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:00:49 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60139 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2FDQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:00:48 -0400
Date: Mon, 4 Jun 2012 18:01:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86, smp: Fix topology checks on AMD MCM
Message-ID: <20120604160113.GI15433@aftab.osrc.amd.com>
References: <20120529174804.GC8263@alberich.amd.com>
 <1338813717-28112-1-git-send-email-bp@amd64.org>
 <1338813830.28282.44.camel@twins>
 <20120604133722.GB15433@aftab.osrc.amd.com>
 <1338817117.28282.48.camel@twins>
 <20120604144850.GF15433@aftab.osrc.amd.com>
 <1338821761.28282.55.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338821761.28282.55.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 04:56:01PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 16:48 +0200, Borislav Petkov wrote:
> > This is cpuinfo_x86.booted_cores and here's how it progresses on this
> > MCM box (below).
> 
>  http://marc.info/?l=linux-kernel&m=133849647709656

Ho-hum, it workie.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
