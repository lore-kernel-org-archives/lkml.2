Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab2EaMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:17:16 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42113 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2EaMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:17:14 -0400
Date: Thu, 31 May 2012 14:17:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531121741.GB14515@aftab.osrc.amd.com>
References: <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com>
 <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com>
 <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com>
 <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
 <4FC748F5.9070709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC748F5.9070709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 07:33:25AM -0300, Mauro Carvalho Chehab wrote:
> Huh? Tony said that some errors report at 4K granularity while, others
> are at cache line size.

Cacheline size is from MCE. This tracepoint is for memory controller
errors where granularity should be pretty stable.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
