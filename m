Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1CNTsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:48:03 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:32470 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1CNTsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:48:01 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/21] Staging: hv: Cleanup vmbus driver
Thread-Topic: [PATCH 00/21] Staging: hv: Cleanup vmbus driver
Thread-Index: AQHL4n95ADocU0k1/0q3XEHRD7vqbZQtOpOA
Date: Mon, 14 Mar 2011 19:47:59 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048019566@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1299794382-709-1-git-send-email-kys@microsoft.com>
 <20110314193716.GA22131@kroah.com>
In-Reply-To: <20110314193716.GA22131@kroah.com>
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
> Sent: Monday, March 14, 2011 3:37 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/21] Staging: hv: Cleanup vmbus driver
> 
> On Thu, Mar 10, 2011 at 01:59:42PM -0800, K. Y. Srinivasan wrote:
> > This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):
> >
> > Cleanup root device management: (patches 1/21 through 10/21)
> > 	1) Get rid of the hv_driver code from the vmbus abstraction
> > 	2) Get rid of unnecessary call sequences and functions
> > 	3) Cleanup the management of the root device by using the
> > 	   standard mechanism for grouping devices under /sys/devices
> 
> I've applied the first 9 patches, as I had questions on 10 and 11, and
> the others after that don't apply without those two applied.

Let me know what the questions are on 10 and 11. When I first sent you the 
patch-set, you had suggested some name changes in 11. Thomas had a comment
on 12.  This morning I sent
the corrected version of 11 as well as 12.
> 
> So, care to resend the rest of the series when we've figured out the
> root device stuff?

Sure. Let me know what the issues/concerns are with regards to root
device handling.

Regards,

K. Y


