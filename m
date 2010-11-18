Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab0KRRwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:52:30 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37094 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755363Ab0KRRw3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:52:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HM/WRXd67UjyP7u3HpUwGtLCnEt/+to3aI3Cwoq1lwWjr4NABgTQxcVKvbbD/m6q2R7tLQEn03g/5+mMzyc60oI+t3aFomz7cSp8E3ih5Ge6ooIJKR+D/sTZw4uCCgKk;
Date: Thu, 18 Nov 2010 09:52:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: maciej.rutecki@gmail.com
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, martin.wilck@ts.fujitsu.com
Subject: Re: [Regression] [2.6.37-rc2] WARNING: at
 drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0x133/0x190()
Message-ID: <20101118095206.195bdbe3@jbarnes-desktop>
In-Reply-To: <201011181828.11943.maciej.rutecki@gmail.com>
References: <201011172153.11313.maciej.rutecki@gmail.com>
	<20101117130018.432b0ec8@jbarnes-desktop>
	<201011181828.11943.maciej.rutecki@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 18:28:11 +0100
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> On środa, 17 listopada 2010 o 22:00:18 Jesse Barnes wrote:
> > On Wed, 17 Nov 2010 21:53:10 +0100
> > 
> > Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> > > Last known good: 2.6.37-rc1
> > > Bad kernel: 2.6.37-rc2
> > > Hardware: VirtualBox
> > 
> > Should be fixed in master now, please re-test.
> 
> Yes, update to latest kernel tree, and kernel works OK.

Great, thanks for confirming.

-- 
Jesse Barnes, Intel Open Source Technology Center
