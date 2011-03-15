Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1COWjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:39:12 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:57981 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1COWjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:39:10 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 05/12] Staging: hv: Get rid of the forward declaration
 for vmbus_uevent
Thread-Topic: [PATCH 05/12] Staging: hv: Get rid of the forward declaration
 for vmbus_uevent
Thread-Index: AQHL417lkAYu+nVIpkSNP5Bo1GpdaZQvbZ8A//+NyfA=
Date: Tue, 15 Mar 2011 22:39:07 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048019AB1@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <20110315222246.GA2339@kroah.com>
In-Reply-To: <20110315222246.GA2339@kroah.com>
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
> Sent: Tuesday, March 15, 2011 6:23 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Mike
> Sterling; Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 05/12] Staging: hv: Get rid of the forward declaration for
> vmbus_uevent
> 
> On Tue, Mar 15, 2011 at 03:03:37PM -0700, K. Y. Srinivasan wrote:
> > Get rid of the forward declaration of vmbus_uevent by moving
> > the code around.
> 
> There are 2 05/12 patches and they are different.
Sorry about that Greg; I had an incorrect commit message that I fixed,
but forgot to delete that patch that was generated with the 
incorrect commit message. Loose the patch that has the subject line:

[PATCH 05/12] Get rid of the forward declaration for vmbus_uevent

You want to keep the one that has the following subject line:

[PATCH 05/12] Staging: hv: Get rid of the forward declaration for vmbus_uevent

I could resend, if you prefer.

Regards,

K. Y

