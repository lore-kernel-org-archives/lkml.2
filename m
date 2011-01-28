Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1A1IxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:53:24 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33233 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab1A1IxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:53:23 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Greg KH'" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20101222044424.GC19006@suse.de> <9E719661EAC44CEBAE5E5E0ABD51B4E0@hacdom.okisemi.com> <20110112030402.GA6884@suse.de>
Subject: RE: [PATCH] pch_phub: add new device ML7213
Date: Fri, 28 Jan 2011 17:53:19 +0900
Message-ID: <07EA96EA612148509DA906049ABCDB25@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20110112030402.GA6884@suse.de>
Thread-Index: AcuyBgHNsWM6zvUhT8SxGCvZCw2X0AMwkkYQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday, January 12, 2011 12:04 PM: Greg KH wrote:
> It is in my "to apply" queue.
It seems our pch_phub patch is not updated to upstream.
Have you reviewed this patch ? or Still in your queue ?

Thanks in advance,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
 

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de] 
> Sent: Wednesday, January 12, 2011 12:04 PM
> To: Tomoya MORINAGA
> Cc: linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk; 
> qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com; Toshiharu Okada
> Subject: Re: [PATCH] pch_phub: add new device ML7213
> 
> On Wed, Jan 12, 2011 at 10:59:35AM +0900, Tomoya MORINAGA wrote:
> > Hi Greg,
> > 
> > On Wednesday, December 22, 2010 1:44 PM, Greg KH wrote:
> > > Put the device type here in the device table, so you 
> don't have to 
> > > check for it again in the probe function.  That way you can save 
> > > some code and keep things simpler and more obvious in the future 
> > > when adding new device ids, that you also have to pick 
> the type for 
> > > it.
> > 
> > Have you reviewed our "v2 patch" which is modified for the above?
> 
> It is in my "to apply" queue.  The hollidays here kept me 
> from working on kernel things for 2 weeks, and now the merge 
> window is happening, but after .38-rc1 is out, I will get to 
> the patch.
> 
> thanks for your patience,
> 
> greg k-h
> 

