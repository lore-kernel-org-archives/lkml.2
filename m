Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab1ESWCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:02:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab1ESWCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:02:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jian Peng <jipeng2005@gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to AHCI spec"
Date: Fri, 20 May 2011 00:03:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105120025.34531.rjw@sisk.pl> <201105192332.16493.rjw@sisk.pl> <BANLkTikR2E2vb=9_ftLS4pcq0ysje7Rqyg@mail.gmail.com>
In-Reply-To: <BANLkTikR2E2vb=9_ftLS4pcq0ysje7Rqyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105200003.13787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011, Jian Peng wrote:
> Hi, Rafael,
> 
> I am using internal WDC laptop HDD. I will give SDD a try even though I only
> have non-Intel SDD now.
> 
> Is your SDD the boot disk (by swapping the built-in HDD out)

Yes, it is.

> or the extra one installed using device bay on Dell laptop?

The machine is not a Dell.  It's an Acer.

Thanks,
Rafael
