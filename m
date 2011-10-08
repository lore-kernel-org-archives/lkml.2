Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1JHTDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 15:03:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab1JHTDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 15:03:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?iso-8859-2?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update pm list address
Date: Sat, 8 Oct 2011 21:05:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
        "Len Brown (Intel)" <len.brown@intel.com>,
        Paul Walmsley <paul@pwsan.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jean Pihet <jean.pihet@newoldbits.com>, Kevin Hilman <khilman@ti.com>,
        magnus.damm@gmail.com, Bojan Smojver <bojan@rexursive.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>, tom.leiming@gmail.com,
        Linux PM <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>, Pavel Machek <pavel@ucw.cz>
References: <CAM_iQpUgC8Enwm9FWYmc9uLvzjYNgXz8WKxBGeZTw3XL8f24eg@mail.gmail.com>
In-Reply-To: <CAM_iQpUgC8Enwm9FWYmc9uLvzjYNgXz8WKxBGeZTw3XL8f24eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110082105.38446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 08, 2011, Américo Wang wrote:
> On Sat, Oct 8, 2011 at 4:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > Due to the continuing outage of lists.linux-foundation.org the linux-pm
> > mailing list is going to be hosted at vger.kernel.org from now on.  The
> > new address of the list is linux-pm@vger.kernel.org .
> >
> 
> Hi, Rafael,
> 
> I think the following patch is needed. :)

That's correct.

Applied to linux-pm/linux-next, but next time please include the entire patch
into the message body.

Thanks,
Rafael


> ----
> 
> Change the pm list address in MAINTAINERS, as it is moved to
> vger.kernel.org now.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
