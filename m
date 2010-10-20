Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0JTUKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:10:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43984 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0JTUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:10:46 -0400
Date: Wed, 20 Oct 2010 22:10:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Fix incorrect data type in
 vmalloc_sync_all()
Message-ID: <20101020201055.GA3971@kryptos.osrc.amd.com>
References: <20101020103642.GA3135@kryptos.osrc.amd.com>
 <tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org>
 <20101020195046.GB16147@aftab>
 <4CBF48C7.3050306@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF48C7.3050306@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, Oct 20, 2010 at 12:53:43PM -0700

> (This is a constant problem, by the way: people seems to want to prefix,
> not suffix, their commentary; "cover letter" style.)  I suspect git
> needs to change, but it's hard to know exactly how to change it.

That's easy, remove the cover letter style when inlining patches further
down the mail.

But yeah, I'm still trying to decide for me which mail attribution
format (set attribution="..." in mutt) is better/clearer:

From: foo
Date: bar

or

On <date>, <person> said:

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
