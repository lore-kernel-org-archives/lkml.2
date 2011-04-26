Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1DZO2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:28:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:53734 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab1DZO2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:28:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="914585732"
Date: Tue, 26 Apr 2011 16:28:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 1/4] MFD: TPS65910: Add new mfd device for TPS65910
Message-ID: <20110426142810.GE3175@sortiz-mobl>
References: <DFDB2D0D-E7B1-4E1E-A3CC-D61052D42E54@slimlogic.co.uk>
 <20110426140001.GA3175@sortiz-mobl>
 <4DB6D085.9000204@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB6D085.9000204@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Tue, Apr 26, 2011 at 03:02:45PM +0100, Liam Girdwood wrote:
> On 26/04/11 15:00, Samuel Ortiz wrote:
> > Hi Jorge,
> > 
> > On Thu, Apr 21, 2011 at 09:35:43AM -0500, Jorge Eduardo Candelaria wrote:
> >> From: Graeme Gregory <gg@slimlogic.co.uk>
> >>
> >> The TPS65910 chip is a power management IC for multimedia and handheld
> >> devices. It contains the following components:
> > The patch looks mostly good to me.
> > You may want to add a locked tps65910_set|clear_bits() API, since it seems
> > you're doing many read(reg), write(reg) sequences in the GPIO driver. That
> > could also be directly used by the regulator one.
> > 
> 
> Samuel, I could all take this series via regulator after the fixes if that's OK with you ?
> 
That's fine, no problem.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
