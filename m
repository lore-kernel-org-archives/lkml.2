Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab2DLO3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:29:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35508 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab2DLO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:29:13 -0400
Date: Thu, 12 Apr 2012 15:29:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
Message-ID: <20120412142904.GA4130@srcf.ucam.org>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
 <20120402235412.GD16303@tassilo.jf.intel.com>
 <alpine.LFD.2.02.1204031001510.2542@ionos>
 <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
 <alpine.LFD.2.02.1204121055200.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1204121055200.2542@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:57:45AM +0200, Thomas Gleixner wrote:

> OK, so now the question is whether the ACPI interrupt can end up being
> shared or not.

Per spec:

"OSPM is required to treat the ACPI SCI interrupt as a sharable, level, 
active low interrupt."

-- 
Matthew Garrett | mjg59@srcf.ucam.org
