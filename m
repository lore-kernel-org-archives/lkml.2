Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1AaKM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:12:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1AaKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:12:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the suspend tree
Date: Mon, 31 Jan 2011 11:12:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110131150730.14b05bef.sfr@canb.auug.org.au>
In-Reply-To: <20110131150730.14b05bef.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311112.02432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from drivers/base/core.c:27:
> drivers/base/power/power.h: In function 'rpm_sysfs_remove':
> drivers/base/power/power.h:71: error: parameter name omitted
> 
> Caused by commit e70e026805c518b1a6e11bc867b14815ac4426df ("PM: Do not
> create wakeup sysfs files for devices that cannot wake up").
> 
> I have used the version of the suspend tree from next-20110121 for today.

Should be fixed now.

Thanks,
Rafael
