Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1DOJho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:37:44 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:55658 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DOJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:37:42 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjAQFTOA
X-RZG-CLASS-ID: mo00
Date: Fri, 15 Apr 2011 11:37:38 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dtor@mail.ru, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest.
Message-ID: <20110415093737.GA15122@aepfle.de>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
 <20110414183804.GB1467@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110414183804.GB1467@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, Konrad Rzeszutek Wilk wrote:

> On Thu, Apr 14, 2011 at 07:26:50PM +0200, Olaf Hering wrote:
> > On Thu, Apr 14, Konrad Rzeszutek Wilk wrote:
> > 
> > > On Thu, Apr 14, 2011 at 05:45:07PM +0200, Igor Mammedov wrote:
> > > >     Mouse stuck after restore of PV guest but buttons are
> > > >     in working condition.
> > > >     If driver has been configured for ABS coordinates at
> > > >     start it will get XENKBD_TYPE_POS events and then
> > > >     suddenly after restore it'll start getting
> > > >     XENKBD_TYPE_MOTION events, that will be dropped later
> > > >     and they won't get into user-space.
> > > > 
> > > >     Regression was introduced by hunk 5 and 6 of 5ea5254
> > > >     in upstream.
> > > > 
> > > >     Driver on restore should ask xen for request-abs-pointer
> > > >     again if it's available. So restore parts that did it 
> > > >     before 5ea5254.
> > > 
> > > Olaf?
> > 
> > This change is correct. Thanks for spotting, Igor.
> 
> Dmitry,
> 
> Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
> with me doing. It fixes a regression introduced by the last hunk of 
> 5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db

Looking through my backlog, I noticed that the patch went also to
stable@kernel.org and is now in various trees already.
So please forward this revert also to stable@suse.de

Olaf
