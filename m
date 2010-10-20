Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0JTWKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:10:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53632 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab0JTWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:10:38 -0400
Date: Thu, 21 Oct 2010 00:11:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Fix incorrect data type in
 vmalloc_sync_all()
Message-ID: <20101020221128.GA16926@aftab>
References: <20101020103642.GA3135@kryptos.osrc.amd.com>
 <tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org>
 <20101020195046.GB16147@aftab>
 <4CBF48C7.3050306@linux.intel.com>
 <20101020201055.GA3971@kryptos.osrc.amd.com>
 <4CBF4D78.1050404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF4D78.1050404@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:13:44PM -0400, H. Peter Anvin wrote:
...

> > From: foo
> > Date: bar
> > 
> > or
> > 
> > On <date>, <person> said:
> > 
> > Hmm...
> > 
> 
> Well, the latter can at least be edited out.
> 
> The former *really* gunks up git.

this decides it then, fall back to the mutt-default. It's not like the
former one is radically better to keep it and disrupt git workflows.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
