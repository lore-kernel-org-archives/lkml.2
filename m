Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810Ab1ESVb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:31:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1ESVbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:31:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jian Peng <jipeng2005@gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant to AHCI spec"
Date: Thu, 19 May 2011 23:32:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105120025.34531.rjw@sisk.pl> <201105191219.27743.rjw@sisk.pl> <BANLkTin6+2obBm=+5Kd5Za1Lq-n4UQ-STw@mail.gmail.com>
In-Reply-To: <BANLkTin6+2obBm=+5Kd5Za1Lq-n4UQ-STw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192332.16493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011, Jian Peng wrote:
> Hi, Rafael,
> 
> Yes. I tested without reverting the patch that caused failure on E6410 (with
> same AHCI controller), The system is Ubuntu 11.04 with default 2.6.39-rc6
> kernel (guess this should be same kernel as yours before reverting the
> patch).
> 
> My system worked well with AC power cable plugging in and out at boot time,
> at runtime, and during "dd if=/dev/sda5 of=/dev/null ..".

What kind of disk did you use?  Mine is an Intel SSD.

> The config file I mentioned is those under /etc/ or other directories that
> is used to control the power management.

They aren't relevant to this issue.

> Did you test my patch? What it the result?

No, I didn't.  Unfortunately, I won't be able to do any tests on the affected
machine in the near future (most probably for the next two weeks or so).

Thanks,
Rafael
