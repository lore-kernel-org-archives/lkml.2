Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2C1NaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:30:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:47887 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2C1NaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:30:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82588419"
Date: Wed, 28 Mar 2012 15:38:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] [3.4] MFD pull request
Message-ID: <20120328133840.GG5759@sortiz-mobl>
References: <20120327105534.GC17616@sortiz-mobl>
 <20120328144824.176ddbb6@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328144824.176ddbb6@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Mar 28, 2012 at 02:48:24PM +0200, Jean Delvare wrote:
> Hi Samuel,
> 
> On Tue, 27 Mar 2012 12:55:34 +0200, Samuel Ortiz wrote:
> > Hi Linus,
> > 
> > This is the MFD pull request for Linux 3.4. This is what we have:
> > 
> > * 4 new drivers: Freescale i.MX on-chip Anatop, Ricoh's RC5T583 and TI's
> > TPS65090 and TPS65217.
> > 
> > * New variants support (8420, 8520 ab9540), cleanups and bug fixes for the
> > abx500 and db8500 ST-E chipsets.
> > 
> > * Some minor fixes and update for the wm8994 from Mark.
> > 
> > * The beginning of a long term TWL cleanup effort coming from the TI folks.
> > 
> > * Various fixes and cleanups for the s5m, TPS659xx, pm860x, and MAX8997
> > drivers.
> 
> What happened to Aaron's Intel ICH mfd driver? It has been floating
> around for quite some time and did receive a fair amount of review and
> testing, I really expected it to make it into kernel 3.4.
If you're talking about this one:
http://www.spinics.net/lists/kernel/msg1307910.html

I don't think I was cc'ed on it.
Could you or Aaron could resend the patchset to me, please ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
