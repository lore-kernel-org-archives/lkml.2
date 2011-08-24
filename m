Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1HXBKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:10:41 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:7960 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1HXBKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:10:34 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 4/8] Staging: hv: vmbus: Fix checkpatch warnings
Thread-Topic: [PATCH 4/8] Staging: hv: vmbus: Fix checkpatch warnings
Thread-Index: AQHMRkFe4rM0R9Bl9U+5mXt+tRWCnJUrvleA//+oECA=
Date: Wed, 24 Aug 2011 01:10:32 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B23CD@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-4-git-send-email-kys@microsoft.com>
 <20110823231657.GC9955@kroah.com>
In-Reply-To: <20110823231657.GC9955@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 23, 2011 7:17 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 4/8] Staging: hv: vmbus: Fix checkpatch warnings
> 
> On Tue, Jul 19, 2011 at 11:44:21AM -0700, K. Y. Srinivasan wrote:
> > Fix  checkpatch warnings in hv.c
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/hv.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
> > index e733173..14e6315 100644
> > --- a/drivers/staging/hv/hv.c
> > +++ b/drivers/staging/hv/hv.c
> > @@ -111,7 +111,7 @@ static u64 do_hypercall(u64 control, void *input, void
> *output)
> >  	u64 hv_status = 0;
> >  	u64 input_address = (input) ? virt_to_phys(input) : 0;
> >  	u64 output_address = (output) ? virt_to_phys(output) : 0;
> > -	volatile void *hypercall_page = hv_context.hypercall_page;
> > +	void *hypercall_page = hv_context.hypercall_page;
> 
> Are you sure?  This was just someone being foolish?  No other reason
> someone tried to use volatile here?

I cannot see any reason why this needs to be volatile.

Regards,

K. Y
> 
> greg k-h

