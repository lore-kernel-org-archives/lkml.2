Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2F3VxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 17:53:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2F3VwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 17:52:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 0/2] platform / x86: Convert remaining drivers to dev_pm_ops-based PM
Date: Sat, 30 Jun 2012 23:56:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Frank Seidel <frank@f-seidel.de>, "Lee, Chun-Yi" <jlee@novell.com>
MIME-Version: 1.0
Message-Id: <201206302356.11014.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After the changes I've sent recently there are two more drivers still using
legacy power management callbacks, so convert them too:

[1/2] hdaps: Use struct dev_pm_ops for power management
[2/2] msi-laptop: Use struct dev_pm_ops for power management

Thanks,
Rafael

