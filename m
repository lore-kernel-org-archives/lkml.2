Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2IZRUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:20:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48760 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab2IZRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:20:43 -0400
Date: Wed, 26 Sep 2012 20:20:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Thermal: Update binding logic based on platform data
Message-ID: <20120926172029.GQ13767@mwanda>
References: <20120925202747.GA19537@elgon.mountain>
 <4D68720C2E767A4AA6A8796D42C8EB591D3756@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591D3756@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 02:39:22PM +0000, R, Durgadoss wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Wednesday, September 26, 2012 1:58 AM
> > To: R, Durgadoss
> > Cc: Zhang, Rui; linux-kernel@vger.kernel.org
> > Subject: re: Thermal: Update binding logic based on platform data
> > 
> > Hello Durgadoss R,
> > 
> > This is a semi-automatic email about new static checker warnings.
> > 
> > The patch 9b70dfa68ae8: "Thermal: Update binding logic based on
> > platform data" from Sep 18, 2012, leads to the following Smatch
> > complaint:
> 
> looking into this. Will submit appropriate fix patches soon.
> 
> Is there a way for me to check/verify these kind of warnings from
> my side ? This way, I can do the check before I submit each patch.
> 

Sure:

git clone git://repo.or.cz/smatch.git
cd smatch
make
(no make install needed)
cd /to/kernel/src/
~/path/to/smatch/smatch_scripts/kchecker drivers/thermal/thermal_sys.c

regards,
dan carpenter

