Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0IBUMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:12:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab0IBUMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:12:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Thu, 2 Sep 2010 22:11:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <htejun@gmail.com>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7F7649.3010409@gmail.com> <201009021633.22869.stephan.diestelhorst@amd.com>
In-Reply-To: <201009021633.22869.stephan.diestelhorst@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022211.26783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Stephan Diestelhorst wrote:
> On Thursday 02 September 2010, 12:02:49 Tejun Heo wrote:
> > For some mysterious reason, certain hardware reacts badly to usual EH
> > actions while the system is going for suspend.  As the devices won't
> > be needed until the system is resumed, ask EH to skip usual autopsy
> > and recovery and proceed directly to suspend.
> 
> Thanks Tejun for this patch. Will test in a second!

I'll wait, then, because it takes a couple of days to reproduce it on my machine.

Thanks,
Rafael
