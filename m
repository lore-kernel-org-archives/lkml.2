Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1C1D3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:29:52 -0400
Received: from twtpemsw4.wistron.com.tw ([220.128.88.34]:3465 "EHLO
	twtpemsw4.wistron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1C1D3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:29:51 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Mar 2011 23:29:51 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Date: Mon, 28 Mar 2011 11:19:45 +0800
Message-ID: <DF7A49853E29834B934025117433841F2BC81F@WHQBEMAIL3.whq.wistron>
In-Reply-To: <20110328025313.GF12596@qtel.sh.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Thread-Index: Acvs83+SWoOdig8ESuiVk1Sos9vczwAAl7Eg
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com> <1301279360-9839-3-git-send-email-guanqun.lu@intel.com> <4D8FF3F8.6000003@linux.intel.com> <20110328025313.GF12596@qtel.sh.intel.com>
From: <Jeff_Cheng@wistron.com>
To: <guanqun.lu@intel.com>, <arjan@linux.intel.com>
Cc: <meego-kernel@lists.meego.com>, <alan@linux.intel.com>,
        <fengguang.wu@intel.com>, <feng.tang@intel.com>,
        <michael.fu@intel.com>, <xingchao.wang@intel.com>,
        <vinod.koul@intel.com>, <jeeja.kp@intel.com>, <gregkh@suse.de>,
        <ramesh.babu@intel.com>, <dharageswari.r@intel.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Mar 2011 03:19:47.0021 (UTC) FILETIME=[FD8D7FD0:01CBECF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guanqun
The msleep is to try disable pop noise. 
If you have better way to disable pop noise, please fix it.
Thanks.

-----Original Message-----
From: Lu Guanqun [mailto:guanqun.lu@intel.com] 
Sent: Monday, March 28, 2011 10:53 AM
To: Arjan van de Ven; Jeff Cheng/WHQ/Wistron
Cc: meego-kernel@lists.meego.com; alan@linux.intel.com; Wu, Fengguang;
Tang, Feng; Fu, Michael; Wang, Xingchao; Koul, Vinod; Kp, Jeeja; Greg
Kroah-Hartman; Babu, Ramesh; R, Dharageswari;
devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO
line

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
> this double msleep sounds rather harsh... why do we need two of these
?
> (heck... why do we need ONE ?)
> 

This is legacy code from Jeff Cheng's patch.
Jeff, could you provide some information on this line?

-- 
guanqun
