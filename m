Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1DERqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:46:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:44363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1DERq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,305,1299484800"; 
   d="scan'208";a="623969050"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
Date: Tue, 5 Apr 2011 11:46:00 -0600
Subject: RE: [PATCH 1/1] staging: sep: remove dependency on memrar driver
Thread-Topic: [PATCH 1/1] staging: sep: remove dependency on memrar driver
Thread-Index: AcvztcZEY3xtDfYQS9Wa1V6epv90EgAAw1Ig
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316154A37E9C@rrsmsx501.amr.corp.intel.com>
References: <1302023393-28057-1-git-send-email-mark.a.allyn@intel.com>
 <20110405172135.GA20622@kroah.com>
In-Reply-To: <20110405172135.GA20622@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Tuesday, April 05, 2011 10:22 AM
To: Allyn, Mark A
Cc: linux-kernel@vger.kernel.org; alan@linux.intel.com; Epshteyn, Eugene
Subject: Re: [PATCH 1/1] staging: sep: remove dependency on memrar driver

On Tue, Apr 05, 2011 at 10:09:53AM -0700, Mark Allyn wrote:
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/staging/sep/sep_driver.c |   59 +------------------------------------

Alan already sent me this patch, and it's in the staging-next tree,
right?  Or is this a new one that I need to do on top of the current
tree as I missed something?

thanks,

greg k-h

==============

Greg:

I pulled next-20110405, along with 2.6.39-rc1 from kernel.org at about 9 AM
on Tuesday, April 05, 2011.

I did not see it in that staging next. When will I see what Alan did on kernel.org?

Mark

