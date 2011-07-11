Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1GKPuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:50:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55957 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab1GKPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:50:13 -0400
Date: Mon, 11 Jul 2011 16:50:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?Keng-Y=FC?= Lin <kengyu@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        ike.pan@canonical.com, vanhoof@canonical.com, kent.lin@canonical.com,
        sylee@canonical.com
Subject: Re: [PATCH 1/2] ideapad-laptop: Ignore an unused VPC notification
Message-ID: <20110711155006.GA14245@srcf.ucam.org>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
 <20110707151023.GA15366@srcf.ucam.org>
 <CADXHx7bnQ49yrL2Uoq=945V1UWMPq-FamCOT81t7Jn4mtEHpkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADXHx7bnQ49yrL2Uoq=945V1UWMPq-FamCOT81t7Jn4mtEHpkQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 03:29:09PM +0800, Keng-Yü Lin wrote:
> On Thu, Jul 7, 2011 at 11:10 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Tue, Jun 28, 2011 at 02:35:53PM +0100, Keng-Yu Lin wrote:
> >> BIOS fires notifications in a constant period with VPC bit 1 set when the
> >> power cord is unplugged.
> >
> > How frequently? That's going to do bad things to power management. It'd
> > be nice to find a way to just make it stop doing that.
> >
> 
> About every 22 seconds.

Ok, this seems fair then.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
