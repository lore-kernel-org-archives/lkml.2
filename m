Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1DKTvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:51:05 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:5592 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1DKTvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:51:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Hyper-V vmbus driver
Thread-Topic: Hyper-V vmbus driver
Thread-Index: Acv4dbOc5a5M0q/iSFeqdVfCMBGUlgAQJ/0AAA02pxA=
Date: Mon, 11 Apr 2011 19:51:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481C9D80@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110411190708.GA21355@suse.de>
In-Reply-To: <20110411190708.GA21355@suse.de>
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
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, April 11, 2011 3:07 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: Hyper-V vmbus driver
> 
> On Mon, Apr 11, 2011 at 06:46:24PM +0000, KY Srinivasan wrote:
> > Greg,
> >
> >
> >
> > Recently, you applied a patch-set from me that cleaned a bunch of architectural
> > issues  in the vmbus driver.
> >
> > With that patch-set, I think I have addressed all architectural issues that I
> > am aware of.
> >
> > I was wondering if you would have the time to let me know what else would
> have
> > to be addressed
> >
> > in the vmbus driver, before it could be considered ready for exiting staging.
> > As always your help is
> >
> > greatly appreciated.
> 
> Hm, interesting word wrapping there, might I consider a "real" email
> client one of these days?  :)
> 
> Anyway, yes, I discussed this with Hank last week at the LF Collab
> summit.  I'll look at the vmbus code later this week when I catch up on
> all of my other work (stable, usb, tty, staging, etc.) that has piled up
> during my 2 week absence, and get back to you with what I feel is still
> needed to be done, if anything.

Thanks Greg. 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h

