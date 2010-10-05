Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab0JEUa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:30:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab0JEUaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:30:22 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 5 Oct 2010 15:30:12 -0500
Subject: RE: [PATCHv2 01/11] staging: tidspbridge: replace iommu custom for
 opensource implementation
Thread-Topic: [PATCHv2 01/11] staging: tidspbridge: replace iommu custom for
 opensource implementation
Thread-Index: Actkp9NfmqBX31Z7TtuyjDbt0cYKGAAJDpQA
Message-ID: <496565EC904933469F292DDA3F1663E602F471C0F2@dlee06.ent.ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <20101005155541.GA24456@kroah.com>
In-Reply-To: <20101005155541.GA24456@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Tuesday, October 05, 2010 10:56 AM
> To: Guzman Lugo, Fernando
> Cc: gregkh@suse.de; felipe.contreras@nokia.com; 
> ameya.palande@nokia.com; Menon, Nishanth; 
> Hiroshi.DOYU@nokia.com; ohad@wizery.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv2 01/11] staging: tidspbridge: replace 
> iommu custom for opensource implementation
> 
> On Thu, Sep 30, 2010 at 09:12:48PM -0500, Fernando Guzman Lugo wrote:
> > Now the tidspbridge uses the API's from iovmm module.
> > 
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> 
> This patch applied, but number 2 and others didn't.  Care to 
> respin those against the new linux-next tree and resend?

Done, you should not have any problem now.

Regards,
Fernando.

> 
> thanks,
> 
> greg k-h
> 