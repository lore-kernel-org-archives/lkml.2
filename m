Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1ESKTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:19:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1ESKTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:19:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jian Peng <jipeng2005@gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to AHCI spec"
Date: Thu, 19 May 2011 12:19:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com> <BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
In-Reply-To: <BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191219.27743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011, Jian Peng wrote:
> Hi, Rafael,

Hi,

> I am using Dell E6410 with same AHCI host controller as your system, but
> could not reproduce the bug you found out (using Ubuntu 11.04 and 2.6.39-rc6
> kernel).

OK, do I think correctly you tested without the patch you sent previously?

> Do you know which config file I need change to perform this testing?

I'm not sure what you mean.  The kernel .config?

Rafael
