Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2LQOCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:02:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50708 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2LQOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:02:44 -0500
Date: Mon, 17 Dec 2012 15:02:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] 3.7 ends in APIC panic
Message-ID: <20121217140238.GA626@gmail.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
 <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
 <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
 <50CE0C82.20708@itwm.fraunhofer.de>
 <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
 <50CEE586.10800@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CEE586.10800@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> wrote:

> On 12/16/2012 07:07 PM, Yinghai Lu wrote:
> >On Sun, Dec 16, 2012 at 10:01 AM, Bernd Schubert
> ><bernd.schubert@itwm.fraunhofer.de> wrote:
> >>>can you post your .config for v3.7 ?
> >>>
> >>>wonder if you have x2apic in .config
> >>
> >>Which setting is it? Config is attached.
> >
> >your config does not have
> >
> >CONFIG_X86_X2APIC=y
> >
> >set.
> >
> >please enable that.
> >
> >your BIOS pre-enable x2apic somehow, so you must have x2apic enabled in kernel.
> >
> >it x2apic really can not be re-enabled by kernel, kernel would disable
> >x2apic automatically.
> 
> The system boots fine with x2apic enabled.
> 
> Thanks a bunch for your help,

I suspect this needs to be fixed/improved: currently it's way 
too easy to disable x2apic support accidentally.

Thanks,

	Ingo
