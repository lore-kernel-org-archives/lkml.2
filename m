Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0ESB0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:26:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:2606 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754725Ab0ESB0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="568439718"
Date: Wed, 19 May 2010 09:27:00 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Dmitry Gromov <gromovd@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LM Sensors <lm-sensors@lm-sensors.org>, Huaxu Wan <huaxu.wan@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 0/2] hwmon: Update coretemp to current
 Intel processors
Message-ID: <20100519012700.GB26906@owl>
References: <20100510035031.GD9181@owl>
 <20100514065808.GA11598@owl>
 <20100517094136.094800562@osadl.org>
 <AANLkTinQlH7LhCAz00WaHqbbslcSqipzVx4tDoQKSqIL@mail.gmail.com>
 <4BF23B36.7030809@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF23B36.7030809@osadl.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:01 Tue 18 May, Carsten Emde wrote:
> Dmitry,
> 
> >>Here comes the current version of the coretemp patches. Huaxu did the
> >>initial work; Jean suggested to submit them directly to Andrew.
> >>
> >>I made some style changes as advised by checkpatch.
> >>
> >>The patches have been tested successfully on Core 2 Duo and Quad, and on
> >>Nehalem and Nehalem/Westmere where temperature readings were plausible and
> >>changed with load as expected. When tested on an Atom processor (N270), the
> >>temperature values were identical to previous versions of the coretemp
> >>module and also changed with load. However, the readings should be higher
> >>by 10 to 15C as compared to the outside temperature of the processor.
> >>Huaxu, could you check? I would guess TjMax to be 105 instead of 90C in these
> >>processors.
> >I apologize, if I ask a stupid question, but are you saying that TjMax in
> >coretemp.c should be set to higher value than Tcase-max value specified in
> >Intel documents?
> Hmm, no. I am saying that I would like the reading to be correct. I
> have measured the outside temperature of the case with an infrared
> thermometer [1] and found it to be higher than the readings returned
> by the coretemp module. In all other CPUs I have, the coretemp
> readings are higher than the case temperature.
> 
> [1] http://www.osadl.org/uploads/media/IPCworld-2008-4.pdf
> 

Hi Carsten,

I have no N270 and infrared thermometer in hand, so I can't check it by myself.
I'll find a channel and file this issue to them. 

Thank you.


Huaxu
