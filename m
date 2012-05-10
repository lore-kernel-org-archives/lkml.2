Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2EJPNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:13:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56412 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab2EJPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:13:08 -0400
Date: Thu, 10 May 2012 17:12:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120510151254.GD32700@aftab.osrc.amd.com>
References: <4FAA6802.9070506@redhat.com>
 <20120509132237.GD22737@aftab.osrc.amd.com>
 <4FAA7649.5080606@redhat.com>
 <20120509140632.GG22737@aftab.osrc.amd.com>
 <4FAA7C1A.3020406@redhat.com>
 <20120509142456.GH22737@aftab.osrc.amd.com>
 <4FABBFAF.20809@redhat.com>
 <20120510134136.GC31257@aftab.osrc.amd.com>
 <4FABD653.7060401@redhat.com>
 <4FABD9F0.6050008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABD9F0.6050008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:08:32PM -0300, Mauro Carvalho Chehab wrote:
> There's also another technical reason to give an acronym to the EDAC
> version that actually works: changeset numbers are not consistent
> within distributions (or other trees, like -stable - although this 60+
> patch series probably won't fit on -stable merging criteria).
>
> Also, this EDAC changeset 60+ patch series can't be represented by a
> single changeset, and requires userspace changes in order to get a
> proper representation model for memories.
>
> Tagging the EDAC core version with a name helps a lot when dealing
> with all the unsolved bugzillas that will be closed by backporting
> this patch series in order to fix the serious EDAC core bug that
> were providing fake information to the end user for all Intel memory
> controllers manufactured after 2005.

edac_module.c:18:#define EDAC_VERSION "Ver: 2.1.0"

Increment that in the last patch.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
