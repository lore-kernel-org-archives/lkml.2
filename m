Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2HUONu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:13:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43773 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2HUONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:13:43 -0400
Date: Tue, 21 Aug 2012 15:13:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Singh Sandeep-B37400 <B37400@freescale.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120821141336.GD21557@sirena.org.uk>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
 <3F1D9DCAAB49B94D88DBE05911FA4E6E511121@039-SN1MPN1-006.039d.mgd.msft.net>
 <20120730160146.GB28703@kroah.com>
 <3F1D9DCAAB49B94D88DBE05911FA4E6E515F98@039-SN1MPN1-001.039d.mgd.msft.net>
 <20120801123738.GA28291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801123738.GA28291@kroah.com>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 05:37:38AM -0700, Greg KH wrote:
> On Wed, Aug 01, 2012 at 12:13:19PM +0000, Singh Sandeep-B37400 wrote:

> > But running a complete voice stack itself is beyond the scope of Freescale.
> > So vendors integrate their solutions with FSL solution.

> And sorry, I was thinking you had kernel drivers that attached to this
> framework, not userspace programs.  Actually, what is the user/kernel
> interface for this framework, I seem to have missed that entirely.  You
> will have to document that quite well, and run it by the linux-api
> mailing list.

This does also sound like we ought to be playing nicer with ALSA rather
than just providing a binary only pipe...
