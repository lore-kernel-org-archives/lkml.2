Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1F3Amq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:42:46 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:45449 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1F3Aml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:42:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Thread-Topic: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Thread-Index: AQHMNo1D9gB2gma+3UOFIc6h3vcrBZTVJ5oA///oTNA=
Date: Thu, 30 Jun 2011 00:42:40 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816BF39@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309374364-23528-1-git-send-email-kys@microsoft.com>
 <20110629190642.GA19698@suse.de>
In-Reply-To: <20110629190642.GA19698@suse.de>
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
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, June 29, 2011 3:07 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: Integrate the time source driver with Hyper-
> V detection code
> 
> On Wed, Jun 29, 2011 at 12:06:04PM -0700, K. Y. Srinivasan wrote:
> > The Hyper-V timesource driver is best integrated with Hyper-V detection code
> > since: (a) Linux guests running on Hyper-V need this timesource and (b)
> > by integrating with Hyper-V detection, we could minimize the code in the
> > timesource driver. Greg, you had  helped me initially in getting the Hyper-V
> > detection code into the kernel (mshyperv.c). I am hoping you can take
> > this patch.
> 
> Nope, it needs to go through the x86 maintainers, please resend it to
> them.  The scripts/get_maintainer.pl file should have told you this,
> right?

Thanks Greg. I have done what you have recommended.

Regards,

K. Y

