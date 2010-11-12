Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0KLMUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:20:12 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1029 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756612Ab0KLMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:20:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 18748
Date: Fri, 12 Nov 2010 13:20:03 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: Bad page state in process (current git)
Message-ID: <20101112122003.GA1572@arch.trippelsdorf.de>
References: <20101110152519.GA1626@arch.trippelsdorf.de>
 <20101110154057.GA2191@arch.trippelsdorf.de>
 <alpine.DEB.2.00.1011101534370.30164@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011101534370.30164@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.10 at 15:46 -0600, Christoph Lameter wrote:
> On Wed, 10 Nov 2010, Markus Trippelsdorf wrote:
> 
> > I found this in my dmesg:
> > ACPI: Local APIC address 0xfee00000
> >  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff8800d0000000-ffff8800d39fffff] on node 0
> 
> That only shows you how the memmap was virtually mapped.

Yes. Fortunately the BUG is gone since I pulled the upcoming drm fixes
from: 
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Maybe 06fba6d4168069d8 fixed it.

-- 
Markus
