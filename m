Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1ELBrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:47:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41418 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1ELBrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:47:23 -0400
Date: Thu, 12 May 2011 02:46:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Greg KH <greg@kroah.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
Message-ID: <20110512014656.GA12513@srcf.ucam.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
 <20110510161137.GA14522@kroah.com>
 <BANLkTimV8=o1zOeVJs9EA64kc+1=RZCJeA@mail.gmail.com>
 <4DCA9CE2.1080307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DCA9CE2.1080307@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 07:27:46AM -0700, H. Peter Anvin wrote:
> On 05/11/2011 06:09 AM, Américo Wang wrote:
> >I agree. It seems that we should enable this by default when APEI and
> >EFI are both enabled, this could be done by Kconfig.
> >
> 
> No, it can't.  That would be a compile-time option, but the
> selection needs to be at runtime.
> 
> However, it is still unclear that this is actually a win at all...

It's a win in that not all EFI platforms are ACPI. I don't think we're 
yet in a position to say which is preferable when we have both.

(Are we really arguing over which broken Intel firmware spec is less 
broken than the other?)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
