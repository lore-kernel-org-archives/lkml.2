Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab1FWQ6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:58:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773Ab1FWQ6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:58:54 -0400
MIME-Version: 1.0
Message-ID: <6ff0f0d5-534e-4403-80f7-edd228618049@default>
Date: Thu, 23 Jun 2011 09:58:35 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: linux-next: manual merge of the tmem tree with the xen-two tree
References: <20110622144611.a900a000.sfr@canb.auug.org.au
 20110622140642.GD5574@dumpdata.com>
In-Reply-To: <20110622140642.GD5574@dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E0370CA.0024:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
> 
> On Wed, Jun 22, 2011 at 02:46:11PM +1000, Stephen Rothwell wrote:
> > Hi Dan,
> >
> > Today's linux-next merge of the tmem tree got a conflict in
> > drivers/xen/Kconfig drivers/xen/tmem.c between commit afec6e04922d ("xen:
> > prepare tmem shim to handle frontswap") from the xen-two tree and commit
> > ac33c46b42ba ("xen: enable frontswap for Xen tmem") from the tmem tree.
> 
> Dan, can you please rebase your #linux-next branch on my #linux-next branch
> so that Stephen's awesome build engine can chug along for this?
> 
> Thanks!
> > I just used the xen-two versions of these files (as they look newer).
> 
> OK, we will sort this out.

Should hopefully all be fixed now.  (Konrad's version of the commit is
indeed the newer version so I have removed the older version from the
tmem tree.)

Thanks,
Dan
