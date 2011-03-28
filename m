Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1C1Cyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:54:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:13840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab1C1Cyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="619691938"
Date: Mon, 28 Mar 2011 10:53:13 +0800
From: Lu Guanqun <guanqun.lu@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>,
        Jeff Cheng <jeff_cheng@wistron.com>
Cc: "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>,
        "Wang, Xingchao" <xingchao.wang@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, "Kp, Jeeja" <jeeja.kp@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Babu, Ramesh" <ramesh.babu@intel.com>,
        "R, Dharageswari" <dharageswari.r@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Message-ID: <20110328025313.GF12596@qtel.sh.intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
 <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
 <4D8FF3F8.6000003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8FF3F8.6000003@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:35:36AM +0800, Arjan van de Ven wrote:
> On 3/27/2011 7:29 PM, Lu Guanqun wrote:
> >
> >   	pr_debug("sst: powering dn nc_power_down ....\n");
> >
> > +	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
> > +	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR) {
> > +		msleep(30);
> > +		nc_set_amp_power(0);
> > +	}
> >   	msleep(30);
> 
> this double msleep sounds rather harsh... why do we need two of these ?
> (heck... why do we need ONE ?)
> 

This is legacy code from Jeff Cheng's patch.
Jeff, could you provide some information on this line?

-- 
guanqun
