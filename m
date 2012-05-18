Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655Ab2ERKCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:02:07 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38663 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762577Ab2ERKCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:02:04 -0400
Date: Fri, 18 May 2012 12:01:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518100147.GC20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337335138.573.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337335138.573.5.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:58:58AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> > Add a barebones implementation for registering persistent events with
> > perf. For that, we don't destroy the buffers when they're unmapped;
> > also, we map them read-only so that multiple agents can access them.
> 
> Yet you don't fail mmap() for VM_WRITE && ->persistent.

I better go fix that after we've agreed on the overall design.

Thanks Peter.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
