Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1DSOzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:55:15 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36153 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1DSOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:55:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDUQEj/5/g==
X-RZG-CLASS-ID: mo00
Date: Tue, 19 Apr 2011 16:55:08 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dtor@mail.ru, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest.
Message-ID: <20110419145507.GA28999@aepfle.de>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
 <20110414183804.GB1467@dumpdata.com>
 <20110415093737.GA15122@aepfle.de>
 <20110419134629.GA8590@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110419134629.GA8590@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, Konrad Rzeszutek Wilk wrote:

> > > Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
> > > with me doing. It fixes a regression introduced by the last hunk of 
> > > 5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
> > 
> > Looking through my backlog, I noticed that the patch went also to
> > stable@kernel.org and is now in various trees already.
> > So please forward this revert also to stable@suse.de
> 
> OK. The upstream git commit is c36b58e8a9112017c2bcc322cc98e71241814303.
> 
> Which stable tree did it go through? 2.6.38 only I presume?

All longterm versions, 2.6.32 and up.

Olaf
