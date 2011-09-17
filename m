Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1IQN02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 09:26:28 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:35762 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1IQN0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 09:26:21 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 0000/0020] Staging: hv: Driver cleanup
Thread-Topic: [PATCH 0000/0020] Staging: hv: Driver cleanup
Thread-Index: AQHMcjvvHNODfxseJE66gSO66GP0qZVQx8YAgADMiIA=
Date: Sat, 17 Sep 2011 13:26:20 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E774F@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <20110916180708.GA32174@kroah.com>
In-Reply-To: <20110916180708.GA32174@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, September 16, 2011 2:07 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 0000/0020] Staging: hv: Driver cleanup
> 
> On Tue, Sep 13, 2011 at 10:59:19AM -0700, K. Y. Srinivasan wrote:
> > Address Greg's VmBus audit comments:
> >
> > 	1) Leverage driver_data field in struct hv_vmbus_device_id to
> > 	   simplify driver code.
> >
> > 	2) Make the util driver conform to the Linux Driver Model.
> >
> > 	3) Get rid of the ext field in struct hv_device by using the
> > 	   driver specific data functionality.
> >
> > 	4) Implement vmbus specific wrapper functions for setting and getting
> > 	   driver specific data..
> >
> > 	5) Other general cleanup.
> 
> I applied 17 of these (i.e. the ones I didn't comment on.)

Thanks Greg. Looking at your comments, it looks like the only
issue in the 3 patches not checked in is related to unnecessary
messages being put out. I will get the fixed patches out soon.

Regards,

K. Y

> 
> greg k-h

