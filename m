Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0KDIha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:37:30 -0400
Received: from smtp.nokia.com ([147.243.128.24]:63277 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325Ab0KDIh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:37:27 -0400
X-Greylist: delayed 4339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 04:37:27 EDT
Subject: Re: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Aaron Durbin <adurbin@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "\"Satoru Moriya\"@google.com" <"Satoru Moriya"@google.com>
In-Reply-To: <4CD1D919.5000209@google.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
	 <20101018153350.18b68c50.akpm@linux-foundation.org>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C1276CEC7@USINDEVS01.corp.hds.com>
	 <4CD1D919.5000209@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 04 Nov 2010 09:20:27 +0200
Message-ID: <1288855227.2075.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 22:50 +0100, ext Aaron Durbin wrote:
> Hope that helps others know that we think such a mechansim is vital. I 
> can post the patches for the common infrastructure if people are interested.

I think Andrew replied that this patch is OK, it only needs some
tweaking. Just tweak it and send out.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

