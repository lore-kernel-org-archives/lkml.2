Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1BWXR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:17:56 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:29499 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1BWXRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:17:55 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "KY Srinivasan" <kys@microsoft.com>
Subject: RE: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Thread-Topic: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Thread-Index: AQHL0ueeEyAMD95LDk2oP6NgPzLQI5QP/GKA//99kOCAAK+KAP//j+Aw
Date: Wed, 23 Feb 2011 23:17:54 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233FAE0E8@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <20110223191533.GB1030@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20110223215658.GB16908@kroah.com>
In-Reply-To: <20110223215658.GB16908@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, February 23, 2011 1:57 PM
> They where compile and run tested. And syslog was not a mess. What did
> > I mess up here? The amount of printouts now are a fraction of what
> > they where before.
> 
> You forgot to put '\n' at the end of all of your pr_XXX lines, so they will be
> merged with the next one, messing up your syslog.  Joe also pointed this
> problem out.
> 
> Take a look at your syslog to see what I am talking about...

I am trying to get some of these patches corrected and out today, but it might
be tomorrow. So far I have lost power for a minutes or so twice this afternoon.

It seems that the threat of snow is enough to lose power where I am in the PNW.

Sigh......

Hank.

