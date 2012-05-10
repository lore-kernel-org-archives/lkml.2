Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab2EJPCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:02:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56289 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab2EJPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:02:23 -0400
Date: Thu, 10 May 2012 17:02:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120510150210.GB32700@aftab.osrc.amd.com>
References: <20120509121326.GA22737@aftab.osrc.amd.com>
 <4FAA6802.9070506@redhat.com>
 <20120509132237.GD22737@aftab.osrc.amd.com>
 <4FAA7649.5080606@redhat.com>
 <20120509140632.GG22737@aftab.osrc.amd.com>
 <4FAA7C1A.3020406@redhat.com>
 <20120509142456.GH22737@aftab.osrc.amd.com>
 <4FABBFAF.20809@redhat.com>
 <20120510134136.GC31257@aftab.osrc.amd.com>
 <4FABD653.7060401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABD653.7060401@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:53:07AM -0300, Mauro Carvalho Chehab wrote:
> Technical reasons were provided already: before this patch series,
> EDAC is *broken*.

Calling it "HERM" doesn't fix it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
